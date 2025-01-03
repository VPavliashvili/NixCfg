{ lib, pkgs, config, ... }:
{
  config.users.users."stranger" = {
    extraGroups =  [ "docker" ];
  };

  config.virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };
}
