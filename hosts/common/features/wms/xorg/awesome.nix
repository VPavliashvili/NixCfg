{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms.xorg.awesome;
  enableGraphics = cfg.hardware.graphics.enable;
  gpuDrivers = cfg.video.drivers;
in {
  options.features.wms.xorg.awesome = {
    enable = mkEnableOption "awesomewm";
    useWallpapers = mkEnableOption "use wallapeprs for this environment/wm";
    defaultTerm = mkOption {
      type = types.str;
      default = "alacritty";
      description = "default terminal emulator under awesomewm";
    };
    hardware.graphics.enable = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "enable hardware acceleration(only set when explicitly needed)";
    };
    video.drivers = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = "set gpu drivers explicitly(need arose when igpu was set as primary from bios)";
    };
  };

  config = mkIf cfg.enable {
    # populating defaultTemrs
    features.wms.xorg.defaultTerms.awesome = cfg.defaultTerm;

    # if true then assign with high priority because if other wm says false its value should be ignored
    features.wms.xorg.useWallpapers = mkIf cfg.useWallpapers (mkForce cfg.useWallpapers);

    features.wms.xorg.enabled = true;

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
    services.xserver = {
      displayManager.startx = {
        enable = true;
      };
      videoDrivers = mkIf (gpuDrivers != null) gpuDrivers;
    };

    hardware.graphics.enable = mkIf (enableGraphics != null) enableGraphics;

    systemd.user.services.lxqt-policykit-agent = {
      description = "lxqt-policykit-agent";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    environment.systemPackages = [
      pkgs.kbdd
      pkgs.flameshot
      pkgs.bemoji
      pkgs.yad
      pkgs.rofi
      pkgs.xev
      pkgs.polybar
      pkgs.xclip
      pkgs.xsel
      pkgs.dmenu
      pkgs.lxqt.lxqt-policykit
    ];
  };
}
