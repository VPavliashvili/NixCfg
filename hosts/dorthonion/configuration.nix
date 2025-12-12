# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, unstable, lib, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./virtualisation.nix
      ./containerisation.nix
      ./features.nix
      ./work.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];


  # two expressions below is for hdmi sound problem
  # after switching to igpu
  # this fix does not fully work but feels like 
  # it this bug occures after longer time boot sessions
  boot.extraModprobeConfig = ''
    # Disable power saving - this is the main fix
    options snd_hda_intel power_save=0 power_save_controller=N
    
    # Additional stability options for Intel audio
    options snd_hda_intel beep_mode=0
  '';
  boot.kernelParams = [ 
    "i915.enable_guc=3"  # Enables GuC firmware for better iGPU stability
  ];

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
  services.dbus.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];

  environment.systemPackages = with pkgs; [
    pulseaudio
    wget
    ntfs3g
    kitty
    mpv
    google-chrome
    librewolf
    util-linux
    ventoy-full
    udisks
    nvtopPackages.full
    smartmontools
    hwloc
    jq
    btop
    tree
    unzip
    avrdude
    qmk
    fastfetch
    ranger
    yazi
    bat
    foot
    ncdu
    stow
    inotify-tools
    jqp
    usbutils
    bat
    dunst
    brightnessctl
    findutils
    mlocate
    killall
    playerctl
    onefetch
    parted
    lsof
    file
    dos2unix
    audacious
    iotop
    keymapp
    pciutils
    pinta
    speedtest-cli
    libnotify
    f3d
    lact
    lm_sensors

    amdgpu_top
    nethogs

    usbutils
    glib
    jmtpfs
    tree
    virt-viewer

    dmidecode
    lshw
    i2c-tools

    mullvad-vpn
  ];
  services.mullvad-vpn.enable = true;
  networking.iproute2.enable = true;

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.keyboard.qmk.enable = true;
  hardware.keyboard.zsa.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.pathsToLink = [ "/share/bash-completion" ];
  
  programs = {
    firefox.enable = true;
    dconf.enable = true;
    # hyprland = {
    #   enable = true;
    #   package = pkgs.hyprland;
    #   xwayland.enable = true;
    # };
    coolercontrol.enable = true;
  };

  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-ocl
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  # Add jellyfin user to render group for hardware access
  users.users.jellyfin.extraGroups = [ "render" "video" ];


  services.gvfs.enable = true;

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
}
