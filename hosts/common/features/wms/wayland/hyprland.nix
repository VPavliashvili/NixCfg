{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms.wayland.hyprland;
in {
  options.features.wms.wayland.hyprland = {
    hy3.enable = mkEnableOption "use hy3 plugin for i3/sway like window management instead of builtin one";
    enable = mkEnableOption "hyprland";
    useWallpapers = mkEnableOption "use wallapeprs for this environment/wm";
    defaultTerm = mkOption {
      type = types.str;
      default = "foot";
      description = "default terminal emulator under hyprland";
    };
  };

  config = mkIf (cfg.enable) {
    features.wms.wayland.defaultTerms.hyprland = cfg.defaultTerm;
    features.wms.xorg.useWallpapers = mkIf cfg.useWallpapers (mkForce cfg.useWallpapers);
    features.wms.wayland.enabled = true;

    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
    };
    environment.systemPackages =
      [
        pkgs.hyprland-per-window-layout
        pkgs.swappy
        pkgs.yad
        pkgs.fuzzel
        pkgs.cliphist
        pkgs.wl-clipboard
        pkgs.grim
        pkgs.slurp
        pkgs.wev
        pkgs.hyprlock
        pkgs.waybar
        pkgs.bemoji
        pkgs.hyprpaper
        pkgs.hyprpolkitagent
      ]
      ++ (optionals cfg.hy3.enable [
        pkgs.hyprlandPlugins.hy3
      ]);
  };
}
