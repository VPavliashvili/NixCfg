{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
in {
  imports = [
    ./hyprland.nix
    ./sway.nix
  ];

  options.features.wms.wayland = {
    enabled = mkOption {
      # these enum values should be bash identifier friendly
      # no hyphens or any other weird stuff here
      # also, these are predefined options meaning they are only available
      # wms to choose from(on the host config side), not the ones will get installed necessarily
      type = types.listOf (types.enum ["none" "hyprland" "sway" "mangowm" "niri"]);
      default = ["none"];
      description = "wayland window managers to install and make available for selection at login";
    };
    terminals = {
      packages = mkOption {
        type = types.listOf types.package;
        default = [pkgs.foot pkgs.wezterm pkgs.kitty pkgs.ghostty];
        description = "terminal emulators available under wayland wms";
      };
    };
    defaultTerms = mkOption {
      type = types.attrsOf types.str;
      default = {};
      internal = true;
      description = "Per-WM default terminal, populated by each window manager submodule";
    };
  };
}
