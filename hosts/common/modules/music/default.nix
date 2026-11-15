{mainUser, ...}: let
  musicLocation = "/mnt/nas/music";
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
}
