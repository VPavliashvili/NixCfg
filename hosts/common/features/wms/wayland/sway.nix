{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms.wayland.sway;
in {
  options.features.wms.wayland.sway = {
    enable = mkEnableOption "swaywm";
    useWallpapers = mkEnableOption "use wallapeprs for this environment/wm";
    defaultTerm = mkOption {
      type = types.str;
      default = "foot";
      description = "default terminal emulator under sway";
    };
  };

  config = mkIf (cfg.enable) {
    features.wms.wayland.defaultTerms.sway = cfg.defaultTerm;
    features.wms.xorg.useWallpapers = mkIf cfg.useWallpapers (mkForce cfg.useWallpapers);
    features.wms.wayland.enabled = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
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
    ];
  };
}
