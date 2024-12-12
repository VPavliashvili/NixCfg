{ pkgs, config, sriovModules, ... }: {

  imports = [
    ./modules/vfio.nix
    ./modules/libvirt.nix
    ./modules/virtualization.nix
    ./modules/kvmfr-options.nix
    (import "${sriovModules}/sriov.nix")
  ];

  virtualisation = {
    # enable libvirt
    libvirtd = {
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
      };
      clearEmulationCapabilities = false;
      deviceACL = [
        "/dev/ptmx"
        "/dev/kvm"
        "/dev/kvmfr0"
        "/dev/vfio/vfio"
        "/dev/vfio/30"
      ];
    };
    # KVM FrameRelay for Looking Glass
    kvmfr = {
      enable = true;
      shm = {
        enable = true;
        size = 64;
        user = "stranger";
        group = "qemu-libvirtd";
        mode = "0666";
      };
    };
    # USB redirection in virtual machine
    spiceUSBRedirection.enable = true;
  };

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    virtualisation.vfio = {
      enable = true;
      # devices = [
      #   "10de:2204" # RTX 3090 Graphics
      #   "10de:1aef" # RTX 3090 Audio
      # ];
      # ignoreMSRs = true;
      # disablePCIeASPM = true;
      # disableEFIfb = false;
    };

    # copied from https://cyberus-technology.de/en/articles/simplify-your-sr-iov-setup-a-guide-to-nixos-modules-and-specializations
    virtualisation.cyberus.intel-graphics-sriov.enable = true;
    virtualisation.virtualbox.host = {
      enable = true;
      enableKvm = true;
      enableHardening = false;
      addNetworkInterface = false;
    };
  };

  # virt-manager
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    util-linux
    looking-glass-client
  ];

  # enable KVM, enable the capacity to launch vm with a virtual socket (network)
  boot.kernelModules = [ "kvm_intel" "vhost_vsock" ];
}
