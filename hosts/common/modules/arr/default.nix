{
  config,
  pkgs,
  unstable,
  inputs,
  mainUser,
  ...
}: {
  # seerr is not available in stable yet, will remove this after 26.05 relese
  # imports = [
  #   "${inputs.unstable}/nixos/modules/services/misc/seerr.nix"
  # ];

  users.groups.media = {};

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
    group = "users";
    webuiPort = 8080;
    openFirewall = true; # opens webuiPort
    torrentingPort = 6881; # opens TCP+UDP for this automatically
  };
}
