{
  lib,
  pkgs,
  unstable,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms.wayland.miracle;
in {
  options.features.wms.wayland.miracle = {
    enable = mkEnableOption "swaywm";
    useWallpapers = mkEnableOption "use wallapeprs for this environment/wm";
    defaultTerm = mkOption {
      type = types.str;
      default = "foot";
      description = "default terminal emulator under miraclewm";
    };
  };

  config = mkIf (cfg.enable) {
    features.wms.wayland.defaultTerms.miracle = cfg.defaultTerm;
    features.wms.xorg.useWallpapers = mkIf cfg.useWallpapers (mkForce cfg.useWallpapers);
    features.wms.wayland.enabled = true;

    # To make the miracle-wm session available if a display manager like SDDM is enabled:
    # i don't use any of display manager but copying from official nixos module
    services.displayManager.sessionPackages = [pkgs.miracle-wm];

    security = {
      polkit.enable = true;
      pam.services.swaylock = {};
    };

    programs = {
      dconf.enable = lib.mkDefault true;
      xwayland.enable = lib.mkDefault true;
    };

    services.graphical-desktop.enable = true;

    xdg.portal = {
      config = {
        "miracle-wm" = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        };
      };
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    systemd.user.targets.miraclewm-session = {
      unitConfig = {
        Description = "miracle-wm session";
        BindsTo = "graphical-session.target";
        Wants = "graphical-session-pre.target";
        After = "graphical-session-pre.target";
        PropagatesStopTo = "graphical-session.target";
      };
    };

    services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;

    environment.systemPackages = [
      unstable.miracle-wm
      pkgs.swaykbdd
      pkgs.swaybg
      pkgs.swappy
      pkgs.bemoji
      pkgs.yad
      pkgs.fuzzel
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.grim
      pkgs.slurp
      pkgs.wev
      pkgs.swaylock-effects
      pkgs.waybar
      pkgs.polkit_gnome
    ];
  };
}
