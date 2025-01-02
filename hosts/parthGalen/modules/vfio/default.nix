{ lib, pkgs, config, ... }:
{
  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';

    boot.kernelParams = [
      "intel_iommu=on"
      "iommu=pt" 
      "i915.enable_guc=3" 
      "i915.max_vfs=7"
    ];

    boot.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
    boot.initrd.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
  };
}
