{ lib, pkgs, unstable, config, ... }:
with lib;
let
  cfg = config.features.cli;
in
{
  options.features.cli = {
    neovim = {
      enable = mkEnableOption "install neovim";
      defaultEditor = mkOption {
        type = types.bool;
        default = true;
        description = "make neovim a default editor";
      };
    };
  };

  config = mkIf cfg.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = cfg.neovim.defaultEditor;
      package = unstable.neovim-unwrapped;
    };
    environment.systemPackages = [
      pkgs.fd
      pkgs.ripgrep
    ];
    environment.variables = mkIf cfg.neovim.defaultEditor {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
