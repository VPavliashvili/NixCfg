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
    terminals = {
      packages = mkOption {
        type = types.listOf types.package; 
        default = [ pkgs.foot pkgs.kitty pkgs.ghostty ];
        description = "list of terminal emulators installed on the system";
      };
      defaultTerm = mkOption {
        type = types.enum [ "foot" "wezterm" "kitty" "ghostty" ];
        default = "foot";
        description = "sets default terminal emulator for system";
      };
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

    {
      environment.systemPackages = cfg.terminals.packages;
    }
  ];
}
