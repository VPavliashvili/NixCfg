{
  config,
  pkgs,
  unstable,
  lib,
  mainUser,
  allowedHosts,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./virtualisation.nix
    ./features.nix
    ./work.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "numenor";

  networking.networkmanager.enable = true;

  age.secrets.wg-private = {
    file = ../../secrets/wg-numenor-private.age;
  };

  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.0.0.4/24" ];
    privateKeyFile = config.age.secrets.wg-private.path;
    autostart = false;
    
    peers = [
      {
        publicKey = "QQ3LpJXa3C0FhAIit1BH0vtfRs4QKJVzNQ+cQ9oCOHk=";
        allowedIPs = [ "192.168.1.0/24" "10.0.0.0/24" ];
        endpoint = "vpn.esgalmar.net:51820";
        persistentKeepalive = 25;
      }
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Tbilisi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.12"
  ];

  environment.systemPackages = with pkgs; [
    pulseaudio
    wget
    ntfs3g
    kitty
    librewolf
    util-linux
    ventoy-full
    udisks
    nvtopPackages.full
    smartmontools
    hwloc
    jq
    tree
    unzip
    fastfetch
    ranger
    bat
    stow
    inotify-tools
    jqp
    usbutils
    bat
    brightnessctl
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

    furmark
    zrok
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.pathsToLink = ["/share/bash-completion"];

  programs = {
    firefox.enable = true;
    dconf.enable = true;
    coolercontrol.enable = true;
    corectrl.enable = true;
  };
  boot.kernelModules = ["nct6775" "coretemp"]; # this for coolercontrol

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff" # for corectrl
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };

  services.gvfs.enable = true;

  # List services that you want to enable:

  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };
  networking.firewall.allowedTCPPorts = [22];

  users.users.${mainUser} = {
    openssh.authorizedKeys.keys = allowedHosts;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
