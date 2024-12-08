{config, pkgs, unstable, ...}: {

  imports = [
    ./oh-my-posh.nix
    ./bash.nix
    ./zellij.nix
    ./neovim.nix
  ];

  home.packages = [
    pkgs.hwloc
    pkgs.jq
    pkgs.btop
    pkgs.tree
    pkgs.unzip
    pkgs.avrdude
    pkgs.qmk
    pkgs.ripgrep
    pkgs.fastfetch
    pkgs.ranger
    pkgs.fzf
    pkgs.yazi
    pkgs.bat
    pkgs.foot
    pkgs.ncdu
    pkgs.stow
    pkgs.inotify-tools
    pkgs.jqp
    pkgs.usbutils
    pkgs.bat
    pkgs.dunst
    pkgs.brightnessctl
    pkgs.gnumake
    pkgs.findutils
    pkgs.mlocate
    pkgs.killall
  ];

  programs.git = {
    enable = true;
    userName = "VPavliashvili";
    userEmail = "v_pavliashvili@yahoo.com";
    aliases = {
        graph = "log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --all --graph --date=relative";
        lgraph = "log --pretty='%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s' --all --decorate --graph";
    };
  };
}
