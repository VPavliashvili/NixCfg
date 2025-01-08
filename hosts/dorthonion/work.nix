{ lib, config, pkgs, ... }:
{
  imports = [
    ../common/modules/work
  ];

  modules.work = {
    vpn.enable = true;
    addRemmina = true;
    addTeams = true;
  };
}
