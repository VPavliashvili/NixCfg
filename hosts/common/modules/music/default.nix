{
  config,
  lib,
  mainUser,
  pkgs,
  inputs,
  ...
}: let
  musicLocation = "/mnt/nas/music";
  libraryLocation = "${musicLocation}/library";
  downloadsLocation = "${musicLocation}/downloads";

  # lidarr from its own nixos-unstable input, nixos-26.05 ships 3.1.0 without
  # plugin support, unstable has >= 3.1.6 which supports plugins (tubifarry)
  lidarrPkgs = inputs.nixpkgs-lidarr.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # pinned to match /nas/music group ownership on moria
  users.groups.music.gid = 2300;
  # for manual imports (beets) and testing
  users.users.${mainUser}.extraGroups = ["music"];

  fileSystems.${musicLocation} = {
    device = "192.168.1.241:/nas/music";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "x-systemd.automount"
      "noauto"
      "_netdev"
      "x-systemd.mount-timeout=10s"
    ];
  };

  age.secrets.navidrome-env.file = ../../../../secrets/navidrome-env.age;

  services.navidrome = {
    enable = true;
    environmentFile = config.age.secrets.navidrome-env.path;
    settings = {
      # module defaults: Address 127.0.0.1, Port 4533, data in /var/lib/navidrome
      # the module bind-mounts MusicFolder read-only into navidrome's sandbox
      MusicFolder = libraryLocation;

      # public share links bypass auth by design, keep off (also the default)
      EnableSharing = false;

      # the file watcher only notices changes written through rivendell's own nfs mount
      # (lidarr, slskd, beets), files changed directly on moria are invisible to it,
      # so rescan hourly as a safety net (default "0" = never)
      Scanner.Schedule = "@every 1h";
    };
  };

  users.users.navidrome.extraGroups = ["music"];

  # never start without the NAS mounted
  systemd.services.navidrome.unitConfig.RequiresMountsFor = [libraryLocation];

  # module's tmpfiles rule on MusicFolder would trigger the nfs automount at boot
  # before network is up (same issue as immich), data dirs come from StateDirectory anyway
  systemd.tmpfiles.settings.navidromeDirs = lib.mkForce {};

  # fail2ban stuff below

  # bans ips with repeated failed navidrome logins (apps and web ui), on the music port only
  services.fail2ban = {
    enable = true;
    # lan never gets banned, incl. nat-reflected traffic that arrives from the router's ip
    ignoreIP = ["127.0.0.1/8" "::1" "192.168.1.0/24"];
    jails.navidrome.settings = {
      enabled = true;
      filter = "navidrome";
      backend = "systemd";
      port = "11443";
      maxretry = 5;
      findtime = "10m";
      bantime = "1h";
    };
  };

  # matches navidrome's own warnings, which carry the real client ip
  # because caddy sets X-Real-IP (see caddy.nix)
  environment.etc."fail2ban/filter.d/navidrome.conf".text = ''
    [Definition]
    # subsonic api (all apps): wrong password or unknown user
    # web ui: failed POST /auth/login (other 401s, e.g. expired ui sessions, are ignored)
    failregex = ^.*level=warning msg="API: Invalid login".* remoteAddr=<HOST>(?:\s|$)
                ^.*level=warning msg="HTTP: POST [^"]*/auth/login"(?=.* httpStatus=401(?:\s|$)).* remoteAddr=<HOST>(?:\s|$)
    journalmatch = _SYSTEMD_UNIT=navidrome.service
  '';

  # contains soulseek + web ui credentials and the api key lidarr uses
  age.secrets.slskd-env.file = ../../../../secrets/slskd-env.age;

  services.slskd = {
    enable = true;
    group = "music";
    environmentFile = config.age.secrets.slskd-env.path;
    # openFirewall stays false: no soulseek port forward for now, same model as qbittorrent
    settings = {
      directories = {
        incomplete = "${downloadsLocation}/incomplete";
        downloads = "${downloadsLocation}/complete";
      };
      # share the library read-only, never downloads or anything else
      shares.directories = [libraryLocation];
    };
  };

  services.lidarr = {
    enable = true;
    package = lidarrPkgs.lidarr;
    group = "music";
    openFirewall = true; # web ui 8686, lan only (not forwarded on opnsense)
  };

  # both write to the nas: never start without it mounted, and keep new files group-writable
  systemd.services.slskd = {
    unitConfig.RequiresMountsFor = [musicLocation];
    serviceConfig.UMask = "0002";
  };
  systemd.services.lidarr = {
    unitConfig.RequiresMountsFor = [musicLocation];
    serviceConfig.UMask = "0002";
  };

  # slskd web ui, lan only (not forwarded on opnsense)
  networking.firewall.allowedTCPPorts = [5030];
}
