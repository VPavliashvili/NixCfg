{
  config,
  pkgs,
  mainUser,
  allowedHosts,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/modules/networking/testing.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "moria"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # my custom option
  modules.networking.testingTools = true;

  # Set your time zone.
  time.timeZone = "Asia/Tbilisi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    speedtest-cli
    btop
    zellij
    tree
    fzf
    powertop
    fastfetch
    tmux

    smartmontools
    lsiutil
    sg3_utils
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-unwrapped;
  };

  programs.coolercontrol = {
    enable = true;
  };
  boot.kernelModules = ["nct6775" "coretemp"]; # this for coolercontrol
  systemd.services.coolercontrold.environment = {
    CC_HOST_IP4 = "0.0.0.0";
    CC_HOST_IP6 = "::";
  };

  programs.git = {
    enable = true;
  };

  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };

  networking.firewall.allowedTCPPorts = [
    22
    11987 # coolercontrol port
    2049 # nfs port
  ];

  users.users.${mainUser} = {
    openssh.authorizedKeys.keys = allowedHosts;
  };

  # zfs stuff start

  # head -c 8 /etc/machine-id
  networking.hostId = "d2d86180";

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = ["nas"];

  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
    pools = ["nas"]; # omit for all pools(rn only having nas)
  };

  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 0;
    hourly = 0;
    daily = 7;
    weekly = 4;
    monthly = 3;
  };
  # zfs stuff end

  # pin 'media' group gid to 992 same as rivendell
  users.groups.media.gid = 992;

  # file sharing and zfs structure related
  # done declaratively instead of manually doing multiple mkdir -p
  # also this will run on every activation and boot but won't touch existing files inside
  systemd.tmpfiles.rules = [
    # d means create directory if missing and enforce mode/owner/group on it
    # and - means nevel clean up
    # order is:  d path mode user group age
    "d /nas/shares/media                          2775 root media -"
    "d /nas/shares/media/downloads                2775 root media -"
    "d /nas/shares/media/downloads/complete       2775 root media -"
    "d /nas/shares/media/downloads/complete/movies   2775 root media -"
    "d /nas/shares/media/downloads/complete/prowlarr 2775 root media -"
    "d /nas/shares/media/downloads/complete/tv       2775 root media -"
    "d /nas/shares/media/downloads/incomplete        2775 root media -"
    "d /nas/shares/media/downloads/incomplete/prowlarr  2775 root media -"
    "d /nas/shares/media/downloads/incomplete/radarr    2775 root media -"
    "d /nas/shares/media/downloads/incomplete/tv-sonarr 2775 root media -"
    "d /nas/shares/media/media                    2775 root media -"
    "d /nas/shares/media/media/books              2775 root media -"
    "d /nas/shares/media/media/Movies             2775 root media -"
    "d /nas/shares/media/media/Tv_Shows           2775 root media -"
  ];

  # share media subdir for rivendell and its arr stack
  services.nfs.server = {
    enable = true;
    # given ip is statically assigned to rivendell
    # on the router(opnsense) level but eventually gotta refactor
    # this(and such cases) out into internal dns names
    exports = ''
      /nas/shares/media 192.168.1.240(rw,sync,no_subtree_check)
    '';
  };

  system.stateVersion = "25.05";
}
