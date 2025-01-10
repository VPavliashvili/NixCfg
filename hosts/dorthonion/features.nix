{ lib, config, pkgs, ... }:
{
  imports = [
    ../common/features
  ];

  features.wms.wm = "sway";
}
