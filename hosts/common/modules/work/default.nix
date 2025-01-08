{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.work;
in 
{
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
  };

  config.environment.systemPackages = []
    ++ (optional (cfg.addRemmina) (pkgs.remmina))
    ++ (optional (cfg.addTeams) (pkgs.teams-for-linux));
}
