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
  features.dev.database.dbms.dbeaver.enable = true;
}
