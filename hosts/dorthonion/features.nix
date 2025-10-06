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
  features.wms.hyprland.hy3.enable = true;

  features.cli.neovim.enable = true;
  features.dev.database.dbms.dbeaver.enable = true;
}
