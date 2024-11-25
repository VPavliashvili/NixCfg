{config, pkgs, unstable, ...}: {

  imports = [
    ./oh-my-posh.nix
    ./bash.nix
    ./zellij.nix
    ./neovim.nix
  ];

  home.packages = [
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
