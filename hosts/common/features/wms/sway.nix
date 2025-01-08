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
  };
}
