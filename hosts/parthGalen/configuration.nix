# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, sriovModules, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./virtualisation.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "parthGalen"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tbilisi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.locate.package = pkgs.mlocate;
  services.locate.enable = true;
  services.locate.localuser = null;
  services.logind.lidSwitch = "ignore";

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.dbus.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  security.polkit.enable = true;
  security.pki.certificateFiles = [
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  ];
  security.pki.certificates = [
    "/home/stranger/certs/Vakhtang-Pavliashvili.pem"
    "/home/stranger/certs/Vakhtang-Pavliashvili.crt"
  ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.keyboard.qmk.enable = true;

  environment.variables = {
    EDITOR = "nvim";
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.pathsToLink = [ "/share/bash-completion" ];

  environment.systemPackages = [
    pkgs.go
    pkgs.python3
    pkgs.openssl
    pkgs.p11-kit
    pkgs.openconnect
    pkgs.vpnc-scripts
    pkgs.libgcc
    pkgs.libclang
    pkgs.pulseaudio
    pkgs.libnotify
    pkgs.gcc
    pkgs.mpv
    pkgs.file
    pkgs.nixd
    pkgs.waybar
    pkgs.util-linux
  ];

  powerManagement.powertop.enable = true;
  programs = {
    light.enable = true;
    dconf.enable = true;
    hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
    };
  };
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
 }
