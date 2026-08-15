{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms;
in {
  options.features.wms.hyprland.hy3.enable = mkEnableOption "use hy3 plugin for i3/sway like window management instead of builtin one";

  config = mkIf (elem "hyprland" cfg.enabled) {
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
      ++ (optionals cfg.hyprland.hy3.enable [
        pkgs.hyprlandPlugins.hy3
      ]);
  };
}
