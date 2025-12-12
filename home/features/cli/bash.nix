# this gives you ability to enable/disable bash
# and easily switch to other shells e.g fish
{
  config,
  lib,
  ...
}:
let
  cfg = config.features.cli.bash;
  launchWindowManager = with lib.strings;
    concatMapStringsSep "\n" (x: x) (config.features.wms.wayland.launchParams or []);
in {
  options.features.cli.bash.enable = lib.mkEnableOption "enable bash";
  options.features.cli.bash.fzf.enable = lib.mkEnableOption "enable fzf for bash";

  config.programs.fzf = lib.mkIf cfg.fzf.enable {
    enable = true;
    enableBashIntegration = true;
    defaultCommand = "fd --type f";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
    
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -200'"
    ];
  };

  config.programs.bash = lib.mkIf cfg.enable {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      neofetch = "fastfetch";
    };
    initExtra = ''
      jump_dir() {
        local p
        if [[ -n "$1" ]]; then
            p="$1"
        else
            p='.'
        fi

        local selected_dir
        selected_dir=$(fd -H -t d . "$p" | fzf +m --height 50% --preview 'tree -C {}')
        cd "$selected_dir"
      }
      inspect_dir() {
        local p
        if [[ -n "$1" ]]; then
            p="$1"
        else
            p='.'
        fi

        local selected_dir
        selected_dir=$(fd -H -t d . "$p" | fzf +m --height 50% --preview 'tree -C {}')
        yazi "$selected_dir"
      }
      edit() {
        local p
        if [[ -n "$1" ]]; then
            p="$1"
        else
            p='.'
        fi

        local selected_file
        selected_file=$(fd -t f -H -E .git | fzf +m --height 50% \
          --preview 'file --mime-type {} | grep -q "text/" && bat --color=always --style=header,grid --line-range :50 {} || echo "Binary file: $(file {})"' \
          --bind 'enter:become(echo {})')
        [[ -n "$selected_file" ]] && nvim "$selected_file"
      }
      play() {
        local p
        if [[ -n "$1" ]]; then
            p="$1"
        else
            p='.'
        fi

        local selected_file
        selected_file=$(fd -H -t f . "$p" | fzf +m --height 50% --preview 'tree -C {}')
        echo "$selected_file"
        mpv "$selected_file"
      }

      export MANPAGER='nvim +Man!'

      alias luamake="$HOME/lua-language-server/3rd/luamake/luamake"
      export LUA_CPATH="/usr/share/lua/5.4/?.so;"
      export PATH="$HOME/bin:$PATH"
      export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
      export PATH="$HOME/go/bin:$PATH"
      export GPG_TTY=$(tty)
      export XDG_SCREENSHOTS_DIR=$HOME/Pictures/Screenshots
      export GRIM_DEFAULT_DIR=$HOME/Pictures/Screenshots

      set -o vi
      bind -m vi-command 'Control-l: clear-screen'
      bind -m vi-insert 'Control-l: clear-screen' 
    '';
    profileExtra = ''
      export TERMINAl=foot
      ${lib.optionalString (launchWindowManager != "") ''
        if [ "$(tty)" = "/dev/tty1" ];then
          ${launchWindowManager}
        fi
      ''}
    '';
  };
}
