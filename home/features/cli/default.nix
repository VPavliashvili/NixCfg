{ config, osConfig, lib, sshpub, ... }: {

  imports = [
    ./oh-my-posh.nix
    ./bash.nix
    ./zellij.nix
  ];

  # * means to attach this public key for any email address
  home.file.".ssh/allowed_signers".text =
    "v_pavliashvili@yahoo.com ${sshpub}";

  programs.git = {
    enable = true;
    userName = "VPavliashvili";
    userEmail = "v_pavliashvili@yahoo.com";
    aliases = {
      graph = "log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --all --graph --date=relative";
      lgraph = "log --pretty='%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s' --all --decorate --graph";
    };
    extraConfig = {
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
      user = {
        signingkey = "/home/stranger/.ssh/id_ed25519.pub";
      };
      commit = {
        gpgSign = true;
      };
    };
  };

  home.file.".config/nvim" = lib.mkIf osConfig.features.cli.neovim.enable {
    # in order for this to work, dotfiles git repo is needed to be cloned
    # and named .dotfiles on home dir (in my case https://github.com/VPavliashvili/.dotfiles)
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
    recursive = true;
  };
}
