{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.virtualisation;

in {
  options.virtualisation = {
    addDocker = mkOption {
      type = types.bool;
      default = false;
      description = "enable docker on system";
    };
  };

  config = mkIf cfg.addDocker {
    virtualisation.docker = {
      enable = true;
      storageDriver = "overlay2";
    };

    users.users."stranger" = {
      extraGroups =  [ "docker" ];
    };

    environment.systemPackages = [
      pkgs.docker-compose
    ];
  };
}
