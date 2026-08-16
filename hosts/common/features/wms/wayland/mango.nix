{
  lib,
  pkgs,
  config,
  unstable,
  ...
}:
with lib; let
  cfg = config.features.wms.wayland.mango;
in {
  options.features.wms.wayland.mango = {
    enable = mkEnableOption "mangowm";
    useWallpapers = mkEnableOption "use wallapeprs for this environment/wm";
    defaultTerm = mkOption {
      type = types.str;
      default = "foot";
      description = "default terminal emulator under mangowm";
    };
  };

  config = mkIf (cfg.enable) {
    features.wms.wayland.defaultTerms.mango = cfg.defaultTerm;
    features.wms.xorg.useWallpapers = mkIf cfg.useWallpapers (mkForce cfg.useWallpapers);
    features.wms.wayland.enabled = true;

    programs.mango = {
      enable = true;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    security.polkit.enable = true;

    environment.systemPackages = [
      pkgs.swappy
      pkgs.bemoji
      pkgs.yad
      pkgs.fuzzel
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.wl-clip-persist
      pkgs.grim
      pkgs.slurp
      pkgs.wev
      pkgs.waybar
      pkgs.polkit_gnome
    ];
  };
}
