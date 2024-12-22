# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, unstable, lib, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "dorthonion"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Tbilisi";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.locate.package = pkgs.mlocate;
  services.locate.enable = true;
  services.locate.localuser = null;
  services.dbus.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stranger = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "plugged" "input" ]; # Enable ‘sudo’ for the user.
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    pulseaudio
    go
    gcc
    python3
    wget
    ntfs3g
    git
    kitty
    mpv
    google-chrome
    waybar
    librewolf
    looking-glass-client
    virt-manager
    util-linux
    libvirt-glib
  ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.keyboard.qmk.enable = true;

  environment.variables = {
    EDITOR = "nvim";
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.pathsToLink = [ "/share/bash-completion" ];
  
  programs = {
    hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
    };
    coolercontrol.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?


  # VIRTUALIZATION
  
  # libvirt.nix
  virtualisation.libvirtd = {
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
  };
  
  users.users."qemu-libvirtd" = {
    # here was runAsRoot check but I am explicitly setting it to false
    # so just adding to these two extra groups directly
    extraGroups = [ "kvm" "input" ];
    isSystemUser = true;
  };

  # vfio.nix
  services.udev.extraRules = ''
    SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
  '';

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt" 
    # ids of rxt 3060Ti and gt 730
    # passing through one for wokr vm and second for gaming
    "vfio-pci.ids=10de:2486,10de:228b,10de:1287,10de:0e0f"
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    (pkgs.callPackage ./kvmfr-git-package.nix { inherit kernel;})
  ];

  boot.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" "kvm_intel" ];
  boot.initrd.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" "kvmfr" ];

  # not in particular but similar logic is in vfio.nix which i ignored cuz was not sure if it worked
  boot.extraModprobeConfig = "options vfio-pci ids=10de:2486,10de:228b,10de:1287,10de:0e0f";
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];

  programs.dconf.enable = true;

  # modules/virtualization.nix modified
  # removed config absractions and directly asisgning values to shm tmpfile
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
