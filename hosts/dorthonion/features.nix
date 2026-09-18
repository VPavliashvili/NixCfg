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
    wayland = {
      hyprland = {
        enable = true;
        useWallpapers = true;
      };
    };
  };

  features.wms.notifications.useDunst = true;

  features.cli.neovim.enable = true;
  features.cli.qmk.enable = true;
  features.cli.fancontrol = true;

  features.dev.database.dbms.dbeaver.enable = true;

  features.gui.gaming.enable = true;
}
