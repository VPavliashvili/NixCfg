{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/features
  ];

  features.wms.wm = "hyprland";
  features.wms.notifications.useDunst = true;

  features.cli.neovim.enable = true;
  features.cli.qmk.enable = true;

  features.gui.gaming.enable = true;
}
