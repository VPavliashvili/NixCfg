{ lib, pkgs, unstable, config, mainUser, ... }:
with lib;
let
  cfg = config.features.gui;
in
{
  options.features.gui = {
    gaming = {
      enable = mkEnableOption "installs and configures software suite for gaming";
      installSteam = mkOption {
        type = types.bool;
        default = true;
        description = "install and configure steam";
      };
      lutris = mkOption {
        type = types.bool;
        default = true;
        description = "install and configure lutris";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.gaming.enable {
      programs = {
        steam.enable = true;
        gamemode.enable = true;
      };
      environment.systemPackages = [
        pkgs.mangohud
        pkgs.protonup-ng
        pkgs.lutris
      ];
      environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${mainUser}/.steam/root/compatibilitytools.d";
    })

    { # core
      services = {
        dbus.enable = true;
      };
      environment.systemPackages = [
        pkgs.obs-studio
        pkgs.mpv
      ];
    }
  ];
}
