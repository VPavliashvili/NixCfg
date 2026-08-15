{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/features
  ];

  # features.wms.wm = "hyprland";
  # features.wms.hyprland.hy3.enable = false; # broken as of 10/06/2026
  # features.wms.enabled = ["hyprland" "awesomewm"];
  features.wms.enabled = ["awesomewm"];
  features.wms.terminals.defaultTerm = "wezterm";

  features.wms.notifications.useDunst = true;

  features.cli.neovim.enable = true;
  features.cli.qmk.enable = true;
  features.cli.fancontrol = true;

  features.gui.gaming.enable = true;
}
