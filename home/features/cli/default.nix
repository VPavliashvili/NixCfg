{ config, osConfig, lib, sshpub, ... }: {

  imports = [
    ./oh-my-posh.nix
    ./bash.nix
    ./zellij.nix
    ./git.nix
    ./terminal.nix
  ];

  home.file.".config/nvim" = lib.mkIf osConfig.features.cli.neovim.enable {
    # in order for this to work, dotfiles git repo is needed to be cloned
    # and named .dotfiles on home dir (in my case https://github.com/VPavliashvili/.dotfiles)
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
    recursive = true;
  };
}
