{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.features.wms.hyprland;
in
{
  options.features.wms.hyprland.enable = mkEnableOption "enable hyprland wm";

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
    ];
  };
}
