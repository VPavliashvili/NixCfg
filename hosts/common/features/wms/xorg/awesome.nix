{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms;
in {
  options.features.wms.xorg.awesome = {
    terminals.defaultTerm = mkOption {
      type = types.enum ["alacritty" "wezterm" "kitty" "ghostty"];
      default = "alacritty";
      description = "default terminal emulator under awesomewm";
    };
  };

  config = mkIf (elem "awesomewm" cfg.enabled) {
    features.wms.xorg.defaultTerms.awesome = cfg.xorg.awesome.terminals.defaultTerm;

    services.xserver = {
      enable = true;

      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          # as nixos.wiki.org suggest
          # add any lua packages required by configuration here
        ];
      };
    };

    # disabling lightdm since i don't need gui for login
    # and its capturing the screen and stays black
    services.xserver.displayManager.lightdm.enable = false;

    # and startx needs to be enabled explicitly
    services.xserver.displayManager.startx.enable = true;
    services.xserver.videoDrivers = ["amdgpu"];
    hardware.graphics.enable = true;

    environment.systemPackages = [
      pkgs.kbdd
      pkgs.flameshot
      pkgs.bemoji
      pkgs.yad
      pkgs.rofi
      pkgs.xev
      pkgs.polybar
      pkgs.clipmenu
      pkgs.xclip
      pkgs.xsel
    ];
  };
}
