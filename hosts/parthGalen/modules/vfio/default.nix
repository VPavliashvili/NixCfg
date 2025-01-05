# this settings are not taking amd options into consideration, only intel

# TODO: disabling target pci devices to passthrough them later(no needed for my igpu laptop, but for dorthonion pc)
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
      default = [];
      description = "e.g. vfio_pci vfio_iommu_type1 vfio";
    };
    initrdModules = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "e.g. vfio_pci vfio_iommu_type1 vfio";
    };
  };

  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';

    boot.kernelParams = cfg.kernelParams;
    boot.kernelModules = cfg.kernelModules;
    boot.initrd.kernelModules = cfg.initrdModules;

    # boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "i915.enable_guc=3" "i915.max_vfs=7" ];
    # boot.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
    # boot.initrd.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
  };
}
