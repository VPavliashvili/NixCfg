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
  features.cli.neovim.enable = true;
  features.cli.qmk.enable = true;

  features.gui.gaming.enable = true;
}
