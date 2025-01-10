{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.features.wms.sway;
in
{
  options.features.wms.sway.enable = mkEnableOption "enable sway wm";

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    environment.systemPackages = [
      pkgs.swaykbdd
      pkgs.swaybg
      pkgs.swappy
      pkgs.wofi-emoji
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
