{
  config,
  lib,
  unstable,
  ...
}:
let
  cfg = config.features.cli.neovim;
in {
  options.features.cli.neovim.enable = lib.mkEnableOption "enable neovim editor";

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      # using unwrapped to avoid '/nvim-python3: Permission denied' error
      # since home-manager is wrapping neovim itself and needs unwrapped package if provided manually
      package = unstable.neovim-unwrapped;
    };

    # in order for this to work, dotfiles git repo is needed to be cloned
    # and named .dotfiles on home dir (in my case https://github.com/VPavliashvili/.dotfiles)
    home.file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
      recursive = true;
    };
  };
}
