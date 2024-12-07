{config, pkgs, unstable, ...}: {

  home.packages = [
    pkgs.spotify
    pkgs.remmina
    pkgs.teams-for-linux
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
