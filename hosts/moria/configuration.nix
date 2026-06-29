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
  ];

  users.users.${mainUser} = {
    openssh.authorizedKeys.keys = allowedHosts;
  };

  system.stateVersion = "25.05";
}
