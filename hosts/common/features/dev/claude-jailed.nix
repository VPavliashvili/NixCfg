# this is a jail for claude-code using bubblewrap
# avoiding full system exposure to it
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.features.dev.claude-jailed;

  claudePkgs = import inputs.nixpkgs-claude {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfreePredicate = p: lib.getName p == "claude-code";
  };

  claudemnt = pkgs.writeShellApplication {
    name = "claudemnt";
    runtimeInputs = [pkgs.bindfs pkgs.coreutils];
    text = ''
      [ $# -eq 1 ] || { echo "usage: claudemnt <path>" >&2; exit 1; }
      src="$(realpath "$1")"
      dst="$HOME/.claude/mnt/$(basename "$src")"

      if [ -e "$dst" ]; then
        echo "claudemnt: '$dst' already exists; claudeumnt '$(basename "$src")' first" >&2
        exit 1
      fi

      if [ -d "$src" ]; then
        mkdir "$dst"
        bindfs -r --no-allow-other "$src" "$dst" || { rmdir "$dst"; exit 1; }
      else
        cp --reflink=auto "$src" "$dst"
      fi
      echo "$dst"
    '';
  };

  claudeumnt = pkgs.writeShellApplication {
    name = "claudeumnt";
    runtimeInputs = [pkgs.coreutils pkgs.util-linux];
    text = ''
      [ $# -eq 1 ] || { echo "usage: claudeumnt <name>" >&2; exit 1; }

      # only plain names inside ~/.claude/mnt; no "../x" escaping the mnt dir
      case "$1" in
        ""|.|..|*/*)
          echo "claudeumnt: invalid name '$1'" >&2
          exit 1 ;;
      esac

      dst="$HOME/.claude/mnt/$1"
      if mountpoint -q "$dst"; then
        fusermount3 -u "$dst" && rmdir "$dst"
      elif [ -d "$dst" ]; then
        rmdir "$dst"
      else
        rm -f "$dst"
      fi
    '';
  };

  # host side: answers image-only clipboard requests
  claudeClipHandler = pkgs.writeShellApplication {
    name = "claude-clip-handler";
    runtimeInputs = [pkgs.wl-clipboard pkgs.gnugrep pkgs.coreutils];
    text = ''
      read -r cmd arg || exit 1
      case "$cmd" in
        types)
          wl-paste --list-types 2>/dev/null \
            | grep -E '^image/(png|jpeg|jpg|gif|webp|bmp)$' || true ;;
        get)
          case "$arg" in
            image/png|image/jpeg|image/jpg|image/gif|image/webp|image/bmp)
              wl-paste --no-newline --type "$arg" ;;
            *) exit 1 ;;
          esac ;;
        *) exit 1 ;;
      esac
    '';
  };

  # jail side: fake wl-paste that only forwards image requests
  claudeWlPasteShim = pkgs.writeShellApplication {
    name = "wl-paste";
    runtimeInputs = [pkgs.socat];
    text = ''
      sock=/run/claude-clip.sock
      [ -S "$sock" ] || exit 1
      req=""
      while [ $# -gt 0 ]; do
        case "$1" in
          -l|--list-types) req="types" ;;
          -t|--type) shift; req="get ''${1:-}" ;;
          --type=*) req="get ''${1#--type=}" ;;
        esac
        shift
      done
      [ -n "$req" ] || exit 1
      printf '%s\n' "$req" | socat -t 30 - UNIX-CONNECT:"$sock"
    '';
  };

  # blocks connecting to abstract unix sockets created outside the jail, most notably
  # xwayland/xorg's @/tmp/.X11-unix/X* which --share-net would otherwise expose
  landlockScopeAbstract = pkgs.writeCBin "landlock-scope-abstract" ''
    #include <linux/landlock.h>
    #include <stdio.h>
    #include <sys/prctl.h>
    #include <sys/syscall.h>
    #include <unistd.h>

    int main(int argc, char **argv) {
      if (argc < 2) { fprintf(stderr, "usage: %s cmd [args...]\n", argv[0]); return 2; }

      /* fail closed: refuse to run unprotected on kernels without scoping (< 6.12) */
      int abi = syscall(SYS_landlock_create_ruleset, NULL, 0, LANDLOCK_CREATE_RULESET_VERSION);
      if (abi < 6) { fprintf(stderr, "landlock: abi %d < 6, abstract socket scoping unsupported\n", abi); return 111; }

      struct landlock_ruleset_attr attr = { .scoped = LANDLOCK_SCOPE_ABSTRACT_UNIX_SOCKET };
      int fd = syscall(SYS_landlock_create_ruleset, &attr, sizeof attr, 0);
      if (fd < 0) { perror("landlock_create_ruleset"); return 111; }
      if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) { perror("prctl"); return 111; }
      if (syscall(SYS_landlock_restrict_self, fd, 0)) { perror("landlock_restrict_self"); return 111; }
      close(fd);

      execvp(argv[1], argv + 1);
      perror("execvp");
      return 127;
    }
  '';

  claude-jailed = pkgs.writeShellApplication {
    name = "claude";
    runtimeInputs = [pkgs.bubblewrap pkgs.git pkgs.coreutils pkgs.socat];
    text = ''
      project="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

      case "$project" in
        "$HOME"|/|/home|/nix|/nix/*|/etc|/etc/*)
          echo "claude-jail: refusing to expose '$project'; cd into a project dir" >&2
          exit 1 ;;
      esac

      mkdir -p "$HOME/.claude/mnt" "$HOME/.cache/nix"

      # make sure the read-only targets exist; --ro-bind-try silently skips missing
      # paths, which would let the jail create e.g. .git/hooks itself
      if [ -d "$project/.git" ]; then
        mkdir -p "$project/.git/hooks"
      fi

      # image-only clipboard bridge for this session
      sock="''${XDG_RUNTIME_DIR:-/tmp}/claude-clip-$$.sock"
      socat -t 30 UNIX-LISTEN:"$sock",fork,mode=600 \
        EXEC:${claudeClipHandler}/bin/claude-clip-handler \
        </dev/null >/dev/null 2>&1 &
      clip_pid=$!
      trap 'kill "$clip_pid" 2>/dev/null; rm -f "$sock"' EXIT
      for _ in 1 2 3 4 5 6 7 8 9 10; do
        [ -S "$sock" ] && break
        sleep 0.05
      done

      bwrap \
        --unshare-all --share-net \
        --die-with-parent \
        --ro-bind /nix/store /nix/store \
        --bind /nix/var/nix/daemon-socket /nix/var/nix/daemon-socket \
        --ro-bind /etc /etc \
        --ro-bind /bin /bin \
        --ro-bind /usr /usr \
        --ro-bind /run/current-system /run/current-system \
        --proc /proc \
        --dev /dev \
        --tmpfs /tmp \
        --dir "''${TMPDIR:-/tmp}" \
        --tmpfs "$HOME" \
        --bind "$HOME/.claude" "$HOME/.claude" \
        --ro-bind "$HOME/.claude/mnt" "$HOME/.claude/mnt" \
        --bind "$HOME/.cache/nix" "$HOME/.cache/nix" \
        --ro-bind-try "$HOME/.gitconfig" "$HOME/.gitconfig" \
        --ro-bind-try "$HOME/.config/git" "$HOME/.config/git" \
        --bind "$project" "$project" \
        --ro-bind-try "$project/.git/hooks" "$project/.git/hooks" \
        --ro-bind-try "$project/.git/config" "$project/.git/config" \
        --setenv CLAUDE_CONFIG_DIR "$HOME/.claude" \
        --setenv NIX_REMOTE daemon \
        --ro-bind-try "$sock" /run/claude-clip.sock \
        --setenv PATH "${claudeWlPasteShim}/bin:$PATH" \
        --chdir "$PWD" \
        ${landlockScopeAbstract}/bin/landlock-scope-abstract \
        ${claudePkgs.claude-code}/bin/claude "$@"
    '';
  };
in {
  options.features.dev.claude-jailed.enable =
    lib.mkEnableOption "Claude Code CLI confined in a bubblewrap jail";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [claude-jailed claudemnt claudeumnt];
  };
}
