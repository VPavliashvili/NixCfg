{ pkgs, config, sriovModules, ... }: {
  imports = [
    ./modules/libvirt
    ./modules/vfio
    ./modules/looking-glass
    ./modules/sriov
  ];

  boot.kernelModules = [ "kvm_intel" "vhost_vsock" ];
}
