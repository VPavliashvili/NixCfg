{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.containerisation;
in {
  options.containerisation = {
    docker = mkOption {
      type = types.bool;
      default = false;
      description = "enable docker on system";
    };
  };

  config = mkIf cfg.docker {
    virtualisation.docker = {
      enable = true;
      storageDriver = "overlay2";
    };

    users.users."stranger" = {
      extraGroups = ["docker"];
    };

    environment.systemPackages = [
      pkgs.docker-compose
    ];
  };
}
