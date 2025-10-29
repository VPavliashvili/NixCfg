{
  pkgs,
  config,
  mainUser,
  ...
}: {
  imports = [
    ../common/modules/virtualisation/libvirt
    ../common/modules/virtualisation/vfio
    ../common/modules/virtualisation/looking-glass
  ];

  virtualisation = {
    vfio = {
      kernelParams = ["intel_iommu=on" "iommu=pt"];
      kernelModules = ["vfio_pci" "vfio_iommu_type1" "vfio" "kvm_intel"];
      initrdModules = ["vfio_pci" "vfio_iommu_type1" "vfio"];
      devices = [
        "10de:2486" # rtx 3060Ti graphics
        "10de:228b" # rtx 3060Ti audio

        "1002:73ff" # rx 6600 graphics
        "1002:ab28" # rx 6600 audio

        # "8086:4680" # igpu
        # "8086:7ad0" # igpu audio
      ];
      blacklistNvidia = true;
    };
    looking-glass = {
      enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/win10_work 660 ${mainUser} kvm -"
    "f /dev/shm/win10_gaming 660 ${mainUser} kvm -"
  ];

  # notes here for looking-glass configuration
  # win10_gaming -> /dev/shm/win10_gaming, spice port 5905, evdev alt-alt, shmem size 64MB
  # win10_work -> /dev/shm/win10_work, spice port 5906, evdev ctrl-ctrl, shmem size 64MB

  # not related to nixos but when setting up looking-glass on vm xml configuration
  # if running intel's hybrid architecture cpu(e.g 12600k) do not forget to add
  # '<maxphysaddr mode="passthrough" limit="39"/>' under <cpu> element
  # otherwise it vm will always crash shortly after start
}
