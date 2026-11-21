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

  claude-jailed = pkgs.writeShellApplication {
    name = "claude";
    runtimeInputs = [pkgs.bubblewrap pkgs.git pkgs.coreutils];
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

      exec bwrap \
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
        --chdir "$PWD" \
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
