# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ];

  networking.hostName = "himring"; # Define your hostname.

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

  environment.variables = {
    http_proxy = "http://172.27.96.1:3128";
    https_proxy = "http://172.27.96.1:3128";
    HTTP_PROXY = "http://172.27.96.1:3128";
    HTTPS_PROXY = "http://172.27.96.1:3128";
    no_proxy = "localhost,127.0.0.1,::1";
    NO_PROXY = "localhost,127.0.0.1,::1";
  };

  nix.settings = {
    http-connections = 25;
    connect-timeout = 5;
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      # This ensures curl uses the proxy
      curl = pkgs.curl.override {
        http2Support = true;
      };
    };
  };

  environment.etc."wgetrc".text = ''
    http_proxy = http://172.27.96.1:3128
    https_proxy = http://172.27.96.1:3128
    use_proxy = on
  '';

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    speedtest-cli
    btop
    zellij
    tree
    smartmontools
    fzf
    powertop
    fastfetch
    inetutils
    stow
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-unwrapped;
  };
  programs.git = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
