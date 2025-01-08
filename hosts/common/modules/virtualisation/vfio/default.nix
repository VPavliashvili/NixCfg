# this settings are not taking amd options into consideration, only intel
{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.virtualisation.vfio;
in {
  options.virtualisation.vfio = {
    kernelParams = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "e.g. this are for igpu sriov laptop: intel_iommu=on iommu=pt i915.enable_guc=3 i915.max_vfs=7";
    };
    kernelModules = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "e.g. vfio_pci vfio_iommu_type1 vfio";
    };
    initrdModules = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "e.g. vfio_pci vfio_iommu_type1 vfio";
    };
    devices = mkOption {
      type = types.listOf (types.strMatching "[0-9a-f]{4}:[0-9a-f]{4}");
      default = [ ];
      example = [ "10de:2486" "10de:228b" ];
      description = "PCI IDs of devices to bind to vfio-pci";
    };
    blacklistNvidia = mkOption {
      type = types.bool;
      default = false;
      description = "Add Nvidia GPU modules to blacklist";
    };
  };

  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';

    boot.kernelParams = cfg.kernelParams ++ (optional (builtins.length cfg.devices > 0)
      ("vfio-pci.ids=" + builtins.concatStringsSep "," cfg.devices));
    boot.kernelModules = cfg.kernelModules;
    boot.initrd.kernelModules = cfg.initrdModules;

    boot.extraModprobeConfig = optionalString (builtins.length cfg.devices > 0)
      ("options vfio-pci ids=" + builtins.concatStringsSep "," cfg.devices);
    boot.blacklistedKernelModules = optionals cfg.blacklistNvidia [ "nvidia" "nouveau" ];
  };
}
