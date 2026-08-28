{
  lib,
  pkgs,
  unstable,
  config,
  mainUser,
  ...
}:
with lib; let
  cfg = config.features.cli;
in {
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
    btop = mkOption {
      type = types.bool;
      default = true;
      description = "install btop";
    };
    yazi = mkOption {
      type = types.bool;
      default = true;
      description = "install yazi";
    };
    fancontrol = mkOption {
      type = types.bool;
      default = false;
      description = "activates my custom fan control script and system configuration";
    };
  };

  config = mkMerge [
    (mkIf cfg.neovim.enable {
      programs.neovim = {
        enable = true;
        defaultEditor = cfg.neovim.defaultEditor;
        package = pkgs.neovim-unwrapped;
      };
      environment.systemPackages = [
        pkgs.fd
        pkgs.ripgrep
        pkgs.tree-sitter
      ];
      environment.variables = mkIf cfg.neovim.defaultEditor {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    })

    (mkIf cfg.btop {
      environment.systemPackages = [pkgs.btop];
    })
    (mkIf cfg.yazi {
      environment.systemPackages = [pkgs.yazi];
    })

    (mkIf cfg.qmk.enable {
      environment.systemPackages = [
        pkgs.pkgsCross.avr.buildPackages.gcc
        pkgs.avrdude
        pkgs.qmk
      ];
      hardware.keyboard.qmk.enable = true;
    })

    (mkIf cfg.fancontrol {
      services.udev.extraRules = ''
        # Allow fans group to control nct6798 PWM fans
        SUBSYSTEM=="hwmon", DRIVERS=="nct6775", RUN+="/bin/sh -c 'chgrp fans /sys/class/hwmon/%k/pwm[1-7] /sys/class/hwmon/%k/pwm[1-7]_enable 2>/dev/null; chmod g+w /sys/class/hwmon/%k/pwm[1-7] /sys/class/hwmon/%k/pwm[1-7]_enable 2>/dev/null'"
      '';

      users.groups.fans = {};
      users.users.${mainUser}.extraGroups = ["fans"];
    })

    {
      # core
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
