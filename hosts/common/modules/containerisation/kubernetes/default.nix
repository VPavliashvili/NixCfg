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
    minikube = mkOption {
      type = types.bool;
      default = false;
      description = "enable minikube on system";
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

    environment.systemPackages = [] ++ (optionals cfg.minikube [pkgs.minikube pkgs.kubectl]);
  };
}
