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
    # xorg.awesome = {
    #   enable = true;
    #   defaultTerm = "alacritty";
    #   video.drivers = ["amdgpu"];
    #   hardware.graphics.enable = true;
    #   useWallpapers = true;
    # };
    wayland.hyprland = {
      enable = true;
      useWallpapers = true;
    };
    wayland.mango = {
      enable = true;
    };
    wayland.sway = {
      enable = true;
    };
  };

  features.wms.notifications.useDunst = true;

  features.cli.neovim.enable = true;
  features.cli.qmk.enable = true;
  features.cli.fancontrol = true;

  features.gui.gaming.enable = true;
  features.gui.midscroll.enable = true;
}
