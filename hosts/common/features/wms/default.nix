{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.features.wms;
in
{
  imports = [
    ./hyprland.nix
    ./sway.nix
  ];

  options.features.wms = {
    wm = mkOption {
      type = types.enum [ "hyprland" "sway" "none"];
      default = "none";
      description = "choose window manager for system to use";
    };
  };

  config = mkMerge [
    (mkIf (cfg.wm == "hyprland") {
      features.wms.hyprland.enable = true;
    })
    (mkIf (cfg.wm == "sway") {
      features.wms.sway.enable = true;
    })
    (mkIf (cfg.wm == "none") {})
  ];
}
