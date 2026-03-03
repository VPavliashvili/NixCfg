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
    vpn.enable = true;
    addRemmina = true;
    addTeams = true;
    noroot = true;
  };
}
