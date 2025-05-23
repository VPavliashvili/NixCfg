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
    concatMapStringsSep "\n" (x: x) config.features.wms.wayland.launchParams;
in {
  options.features.cli.bash.enable = lib.mkEnableOption "enable bash";

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        neofetch = "fastfetch";
      };
      initExtra = ''
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
        if [ "$(tty)" = "/dev/tty1" ];then
          ${launchWindowManager}
        fi
      '';
    };
  };
}
