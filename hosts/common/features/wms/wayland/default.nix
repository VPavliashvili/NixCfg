{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  gpuCfg = config.features.wms.wayland.devices.gpu;
in {
  imports = [
    ./hyprland.nix
    ./sway.nix
    ./mango.nix
    ./miracle.nix
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

    # this option is relevant for the systems which
    # use both, igpu and dgpu and setting igpu as primary from bios
    # causes crashes on wayland systems, because compositor
    # picks wrong device when launching
    devices.gpu = {
      primary = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "pci bus id of the gpu Wayland compositors should treat as primary. this value should be get from /dev/dri/by-path/pci-{bus}-card";
      };
      secondary = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "secondary(fallback) gpu in case primary one has problems or experimenting";
      };
    };
  };

  config = {
    services.udev.extraRules = ''
      ${lib.optionalString (gpuCfg.primary != null) ''
        KERNEL=="card*", KERNELS=="${gpuCfg.primary}", SUBSYSTEM=="drm", SYMLINK+="dri/wayland-primary-gpu"
      ''}

      ${lib.optionalString (gpuCfg.secondary != null) ''
        KERNEL=="card*", KERNELS=="${gpuCfg.secondary}", SUBSYSTEM=="drm", SYMLINK+="dri/wayland-secondary-gpu"
      ''}
    '';
  };
}
