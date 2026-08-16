{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
in {
  imports = [
    ./awesome.nix
  ];

  options.features.wms.xorg = {
    enabled = mkOption {
      type = types.bool;
      default = false; # even if one xorg wm is enabled this value should be true and set from every xorg wm
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
        default = [pkgs.alacritty pkgs.wezterm pkgs.kitty pkgs.ghostty];
        description = "terminal emulators available under xorg wms";
      };
    };
    useWallpapers = mkEnableOption "usage of wallpapers on this system(used in home manager)";
  };
}
