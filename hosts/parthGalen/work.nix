{ lib, config, pkgs, ... }:
{
  imports = [
    ../common/modules/work
  ];

  config.environment.systemPackages = [
    pkgs.remmina
    pkgs.teams-for-linux
  ];
}
