# in this section(./dotfiles) comes program configs which will reside separately from
# nix configuration repo(i.e this repo), there is second variant too
# e.g oh-my-posh is done in that way, when it has defined configuration inside nix file

# in order for this to work, dotfiles git repo is needed to be cloned
# and named .dotfiles on home dir (in my case https://github.com/VPavliashvili/.dotfiles)
{ config, ...}: {

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
    recursive = true;
  };
}
