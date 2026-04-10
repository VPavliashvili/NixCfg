{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../common/modules/virtualisation/libvirt
    ../common/modules/virtualisation/vfio
    ../common/modules/virtualisation/looking-glass
    ../common/modules/virtualisation/sriov
  ];

  virtualisation = {
    waydroid.enable = true;
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
      kernelParams = [
        "iommu=pt"
      ];
      kernelModules = ["vfio_pci" "vfio_iommu_type1" "vfio" "kvm_intel" "vhost_vsock"];
      initrdModules = ["vfio_pci" "vfio_iommu_type1" "vfio"];
    };
    looking-glass = {
      enable = true;
      kvmfr = {
        enable = true;
        size = 64;
      };
    };
  };
}
