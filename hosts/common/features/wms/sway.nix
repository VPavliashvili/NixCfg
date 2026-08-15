{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms;
in {
  config = mkIf (elem "sway" cfg.enabled) {
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
