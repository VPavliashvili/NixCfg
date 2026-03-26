{
  lib,
  config,
  osConfig,
  pkgs,
  unstable,
  ...
}:
with lib; let
  gaming = osConfig.features.gui.gaming;
in {
  home.file.".config/MangoHud/MangoHud.conf" = mkIf gaming.useMangohud {
    text = ''
      no_display

      fps
      frametime
      frame_timing=1

      gpu_stats
      gpu_load_change
      gpu_temp
      gpu_junction_temp
      gpu_mem_temp
      gpu_fan
      vram

      cpu_stats
      cpu_temp
      cpu_mhz

      ram
    '';
  };

  home.packages = [
    pkgs.spotify
    pkgs.vesktop
    pkgs.chromium
    pkgs.libreoffice
    pkgs.evince
    pkgs.vivaldi
    pkgs.pavucontrol
    pkgs.networkmanagerapplet
    pkgs.blueman
    pkgs.brave
    pkgs.nwg-look
    pkgs.zed-editor
    unstable.qbittorrent
  ];
}
