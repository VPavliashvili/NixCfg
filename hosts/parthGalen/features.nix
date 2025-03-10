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
}
