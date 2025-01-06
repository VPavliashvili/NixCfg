{ pkgs, config, ... }: {
  imports = [
    ../common/modules/virtualisation/libvirt
    ../common/modules/virtualisation/vfio
    ../common/modules/virtualisation/looking-glass
    ../common/modules/virtualisation/docker
  ];

  virtualisation = {
    addDocker = true;
    vfio = {
      kernelParams = [ "intel_iommu=on" "iommu=pt" "vfio-pci.ids=10de:2486,10de:228b,10de:1287,10de:0e0f" ];
      kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" "kvm_intel" ];
      initrdModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
    };
    looking-glass = {
      enable = true;
    };
  };

  boot.extraModprobeConfig = "options vfio-pci ids=10de:2486,10de:228b,10de:1287,10de:0e0f";
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];

  systemd.tmpfiles.rules = [
    "f /dev/shm/win10_work 660 stranger kvm -"
    "f /dev/shm/win10_gaming 660 stranger kvm -"
  ];

  # notes here for looking-glass configuration
  # win10_gaming -> /dev/shm/win10_gaming, spice port 5905, evdev alt-alt, shmem size 64MB
  # win10_work -> /dev/shm/win10_work, spice port 5906, evdev ctrl-ctrl, shmem size 64MB

  # not related to nixos but when setting up looking-glass on vm xml configuration
  # if running intel's hybrid architecture cpu(e.g 12600k) do not forget to add
  # '<maxphysaddr mode="passthrough" limit="39"/>' under <cpu> element
  # otherwise it vm will always crash shortly after start
}

    
