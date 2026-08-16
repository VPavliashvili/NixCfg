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
    ./mango.nix
  ];

  options.features.wms.wayland = {
    enabled = mkOption {
      type = types.bool;
      default = false; # even if one wayland wm is enabled this value should be true and set from every wayland wm
      internal = true;
      description = "used to determine to active xorg related stuff";
    };
    defaultTerms = mkOption {
      type = types.attrsOf types.str;
      default = {};
      internal = true;
      description = "Per-WM default terminal, populated by each window manager submodule";
    };
    terminals = {
      packages = mkOption {
        type = types.listOf types.package;
        default = [pkgs.foot pkgs.wezterm pkgs.kitty pkgs.ghostty];
        description = "terminal emulators available under wayland wms";
      };
    };
    useWallpapers = mkEnableOption "usage of wallpapers on this system(used in home manager)";
  };
}
