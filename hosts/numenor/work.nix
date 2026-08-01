{
  lib,
  config,
  pkgs,
  mainUser,
  ...
}: {
  imports = [
    ../common/modules/work
  ];

  modules.work = {
    vpn.enable = false;
    addRemmina = false;
    addTeams = true;
    noroot = false;
  };
}
