# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, mainUser, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./virtualisation.nix
      ./containerisation.nix
      ./features.nix
      ./work.nix
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
  services.logind.lidSwitch = "ignore";

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.dbus.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.keyboard.qmk.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.pathsToLink = [ "/share/bash-completion" ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];

  environment.systemPackages = [
    pkgs.audacious
    pkgs.bat
    pkgs.brightnessctl
    pkgs.btop
    pkgs.dos2unix
    pkgs.dunst
    pkgs.fastfetch
    pkgs.file
    pkgs.findutils
    pkgs.foot
    pkgs.fzf
    pkgs.ghostty
    pkgs.hwloc
    pkgs.inotify-tools
    pkgs.iotop
    pkgs.jq
    pkgs.jqp
    pkgs.killall
    pkgs.kitty
    pkgs.libclang
    pkgs.libgcc
    pkgs.libnotify
    pkgs.librewolf
    pkgs.lsof
    pkgs.mlocate
    pkgs.mpv
    pkgs.ncdu
    pkgs.ntfs3g
    pkgs.obs-studio
    pkgs.onefetch
    pkgs.parted
    pkgs.playerctl
    pkgs.pulseaudio
    pkgs.ranger
    pkgs.smartmontools
    pkgs.stow
    pkgs.tree
    pkgs.udisks
    pkgs.unzip
    pkgs.usbutils
    pkgs.util-linux
    pkgs.ventoy-full
    pkgs.wget
    pkgs.yazi
    pkgs.android-tools
    pkgs.qmk
    pkgs.krita
    pkgs.mangohud
    pkgs.protonup
    pkgs.lutris
  ];


  powerManagement.powertop.enable = true;
  programs = {
    light.enable = true;
    dconf.enable = true;
    steam.enable = true;
    gamemode.enable = true;
  };

  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${mainUser}/.steam/root/compatibilitytools.d";
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
 }
