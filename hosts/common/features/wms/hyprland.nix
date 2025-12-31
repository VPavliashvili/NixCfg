{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.features.wms.hyprland;
in
{
  options.features.wms.hyprland.enable = mkEnableOption "enable hyprland wm";
  options.features.wms.hyprland.hy3.enable = mkEnableOption "use hy3 plugin for i3/sway like window management instead of builtin one";

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
    };
    environment.systemPackages = [
      pkgs.hyprland-per-window-layout
      pkgs.swappy
      pkgs.yad
      pkgs.fuzzel
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.grim
      pkgs.slurp
      pkgs.wev
      pkgs.swaylock-effects
      pkgs.waybar
      pkgs.bemoji
      pkgs.hyprpaper
    ] ++ (optionals cfg.hy3.enable [
      pkgs.hyprlandPlugins.hy3
    ]);
  };
}
