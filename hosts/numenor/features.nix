{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/features
  ];

  features.wms.xorg.enabled = ["awesomewm"];
  features.wms.xorg.awesome.terminals.defaultTerm = "alacritty";

  features.wms.notifications.useDunst = true;

  features.cli.neovim.enable = true;
  features.cli.qmk.enable = true;
  features.cli.fancontrol = true;

  features.gui.gaming.enable = true;
}
