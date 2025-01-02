{ lib, pkgs, config, ... }:
{
  config.users.users."qemu-libvirtd" = {
    group = "qemu-libvirtd";
    extraGroups =  [ "kvm" "input" ];
    isSystemUser = true;
  };

  config.virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
      swtpm.enable = true;
      runAsRoot = false;
      verbatimConfig = ''
        clear_emulation_capabilities = 0
        cgroup_device_acl = [
          "/dev/ptmx",
          "/dev/kvm",
          "/dev/kvmfr0",
          "/dev/vfio/vfio",
          "/dev/vfio/30"
        ]
      '';
    };
  };
}
