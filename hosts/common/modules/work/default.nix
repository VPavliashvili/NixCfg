{
  lib,
  config,
  pkgs,
  mainUser,
  ...
}:
with lib; let
  cfg = config.modules.work;
in {
  imports = [
    ./vpn.nix
  ];

  options.modules.work = {
    addRemmina = mkOption {
      type = types.bool;
      default = false;
      description = "install remmina software";
    };
    addTeams = mkOption {
      type = types.bool;
      default = false;
      description = "install teams for linux";
    };
    noroot = mkOption {
      type = types.bool;
      default = true;
      description = "avoid openconnect to require root permission(used for my custom work vpn connection script)";
    };
  };

  config.security = mkIf cfg.noroot {
    sudo.extraRules = [
      {
        users = [mainUser];
        commands = [
          {
            command = "${pkgs.openconnect}/bin/openconnect";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
    wrappers.openconnect = {
      source = "${pkgs.openconnect}/bin/openconnect";
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+ep";
    };
  };

  config.environment.systemPackages =
    []
    ++ (optional (cfg.addRemmina) (pkgs.remmina))
    ++ (optional (cfg.addTeams) (pkgs.teams-for-linux));
}
