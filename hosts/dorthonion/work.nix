{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/modules/work
  ];

  modules.work = {
    vpn.enable = true;
    addRemmina = true;
    addTeams = true;
  };

  security.sudo.extraRules = [
    {
      users = ["stranger"];
      commands = [
        {
          command = "${pkgs.openconnect}/bin/openconnect";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  security.wrappers.openconnect = {
    source = "${pkgs.openconnect}/bin/openconnect";
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin+ep";
  };
}
