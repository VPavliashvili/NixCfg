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
    qmk = {
      enable = mkEnableOption "systemwide capability to compile/flash qmk firmware";
    };
  };

  config = mkMerge [
    (mkIf cfg.neovim.enable {
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
    })

    (mkIf cfg.qmk.enable {
      environment.systemPackages = [
        pkgs.pkgsCross.avr.buildPackages.gcc
        pkgs.avrdude
        pkgs.qmk
      ];
      hardware.keyboard.qmk.enable = true;
    })

    { # core
      services.locate.package = pkgs.mlocate;
      services.locate.enable = true;
      environment.systemPackages = [
        pkgs.mlocate
        pkgs.findutils
        pkgs.ncdu
      ];
    }
  ];
}
