{
  lib,
  pkgs,
  unstable,
  config,
  mainUser,
  ...
}:
with lib; let
  cfg = config.features.gui;
in {
  options.features.gui = {
    gaming = {
      enable = mkEnableOption "installs and configures software suite for gaming";
      installSteam = mkOption {
        type = types.bool;
        default = true;
        description = "install and configure steam";
      };
      useMangohud = mkOption {
        type = types.bool;
        default = true;
        description = "use mangohud for fps overlay";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.gaming.enable {
      programs = {
        steam = mkIf cfg.gaming.installSteam {enable = true;};
        gamemode.enable = true;
      };
      environment.systemPackages =
        [
          pkgs.lutris
          pkgs.protonplus
        ]
        ++ (optionals cfg.gaming.useMangohud [
          pkgs.mangohud
          pkgs.vulkan-tools
        ]);
      environment.sessionVariables = mkMerge [
        (mkIf cfg.gaming.installSteam {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${mainUser}/.steam/root/compatibilitytools.d";
        })
        (mkIf cfg.gaming.useMangohud {
          MANGOHUD = "1";
        })
      ];
    })
    {
      # core
      services = {
        dbus.enable = true;
      };
      environment.systemPackages = [
        pkgs.obs-studio
        pkgs.mpv
        pkgs.ristretto
        pkgs.tumbler
        pkgs.evince
      ];
    }
  ];
}
