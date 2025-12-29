{ lib, config, pkgs, ... }:
{
  imports = [
    ./wms
    ./cli
    ./dev
    ./gui
  ];
}
