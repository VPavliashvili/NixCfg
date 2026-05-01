{
  config,
  pkgs,
  ...
}: {
  users.groups.media = {};

  services.deluge = {
    enable = true;
    group = "media";
    web = {
      enable = true;
      openFirewall = true;
    };
  };

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

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };

  services.flaresolverr = {
    enable = true;
    openFirewall = true;
  };
}
