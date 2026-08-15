{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms;
in {
  imports = [
    ./hyprland.nix
    ./sway.nix
  ];

  options.features.wms = {
    enabled = mkOption {
      # these enum values should be bash identifier friendly
      # no hyphens or any other weird stuff here
      type = types.listOf (types.enum ["none" "hyprland" "sway"]);
      default = ["none"];
      description = "window managers to install and make available for selection at login";
    };
    terminals = {
      packages = mkOption {
        type = types.listOf types.package;
        default = [pkgs.foot pkgs.wezterm pkgs.kitty pkgs.ghostty];
        description = "list of terminal emulators installed on the system";
      };
      defaultTerm = mkOption {
        type = types.enum ["foot" "wezterm" "kitty" "ghostty"];
        default = "foot";
        description = "sets default terminal emulator for system";
      };
    };
    notifications = {
      useDunst = mkEnableOption "install dunst";
    };
  };

  config = mkMerge [
    (mkIf cfg.notifications.useDunst {environment.systemPackages = [pkgs.dunst];})
    {environment.systemPackages = cfg.terminals.packages;}
  ];
}
