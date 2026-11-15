{
  config,
  lib,
  mainUser,
  ...
}: let
  musicLocation = "/mnt/nas/music";
  libraryLocation = "${musicLocation}/library";
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
}
