{
  config,
  pkgs,
  unstable,
  inputs,
  mainUser,
  ...
}: {
  users.groups.media.gid = 992; # 'media' auto assigned gid 992 and now pinning to it
  users.users.${mainUser}.extraGroups = ["media"];

  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.seerr = {
    enable = true;
    openFirewall = true;
    package = unstable.seerr;
  };

  services.flaresolverr = {
    enable = true;
    openFirewall = true;
  };

  services.qbittorrent = {
    enable = true;
    user = mainUser;
    group = "media";
    webuiPort = 8080;
    openFirewall = true; # opens webuiPort
    torrentingPort = 6881; # opens TCP+UDP for this automatically
  };
}
