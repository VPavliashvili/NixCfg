{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/features
  ];

  features.wms = {
    xorg.awesome = {
      enable = true;
      defaultTerm = "alacritty";
      video.drivers = ["amdgpu"]; # also explicitly setting for rx 6600
      hardware.graphics.enable = true;
      useWallpapers = true;
    };
    wayland = {
      hyprland = {
        enable = true;
        useWallpapers = true;
      };
      mango = {
        enable = true;
      };
      sway = {
        enable = true;
      };
      miracle = {
        enable = true;
      };

      devices.gpu = {
        primary = "0000:03:00.0"; # rx 6600
        secondary = "0000:00:02.0"; # integrated igpu set as primary inside bios(for sr-iov to work)
      };
    };
  };

  features.wms.notifications.useDunst = true;

  features.cli.neovim.enable = true;
  features.cli.qmk.enable = true;
  features.cli.fancontrol = true;

  features.gui.gaming.enable = true;
  features.gui.midscroll.enable = true;
}
