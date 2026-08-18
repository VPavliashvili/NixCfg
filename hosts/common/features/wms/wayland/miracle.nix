{
  lib,
  pkgs, # stable channel
  unstable, # unstable channel
  config,
  ...
}:
with lib; let
  cfg = config.features.wms.wayland.miracle;
in {
  disabledModules = [
    "programs/wayland/miracle-wm.nix"
  ];

  imports = [
    "${unstable.path}/nixos/modules/programs/wayland/miracle-wm.nix"
  ];

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

    programs.wayland.miracle-wm.enable = true;

    xdg.portal = {
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

    security.polkit.enable = true;

    environment.systemPackages = [
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
