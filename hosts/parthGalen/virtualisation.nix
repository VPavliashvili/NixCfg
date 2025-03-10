{ pkgs, config, sriovModules, ... }: {
  imports = [
    ../common/modules/virtualisation/libvirt
    ../common/modules/virtualisation/vfio
    ../common/modules/virtualisation/looking-glass
    ../common/modules/virtualisation/sriov
  ];

  virtualisation = {
    libvirtd = {
      deviceACL = [
        "/dev/ptmx"
        "/dev/kvm"
        "/dev/kvmfr0"
        "/dev/vfio/vfio"
        "/dev/vfio/30"
      ];
    };
    vfio = {
      kernelParams = [ "intel_iommu=on" "iommu=pt" "i915.enable_guc=3" "i915.max_vfs=7" ];
      kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" "kvm_intel" "vhost_vsock" ];
      initrdModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
    };
    sriov.enable = true;
    looking-glass = {
      enable = true;
      kvmfr = {
        enable = true;
        size = 64;
      };
    };
  };
}
