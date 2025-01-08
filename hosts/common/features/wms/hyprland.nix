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
  };
}
