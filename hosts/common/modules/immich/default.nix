{
  lib,
  pkgs,
  inputs,
  ...
}: let
  mediaLocation = "/mnt/nas/immich";
  # separate nixpkgs input so Immich updates independently of everything else
  immichPkgs = inputs.nixpkgs-immich.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # use the Immich module from the same nixpkgs as the package
  imports = [
    "${inputs.nixpkgs-immich}/nixos/modules/services/web-apps/immich.nix"
  ];
  disabledModules = ["services/web-apps/immich.nix"];

  # pinned to match /nas/immich ownership on moria
  users.groups.immich.gid = 2283;
  users.users.immich = {
    uid = 2283;
    group = "immich";
    isSystemUser = true;
  };

  fileSystems.${mediaLocation} = {
    device = "192.168.1.241:/nas/immich";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "x-systemd.automount"
      "noauto"
      "_netdev"
    ];
  };

  services.immich = {
    enable = true;
    package = immichPkgs.immich;
    inherit mediaLocation;
    host = "0.0.0.0";
    port = 2283;
    openFirewall = true;
  };

  services.postgresql.package = pkgs.postgresql_18;

  # never start without the NAS mounted
  systemd.services.immich-server.unitConfig.RequiresMountsFor = [mediaLocation];

  # module's tmpfiles rule chmods mediaLocation as root: fails under root_squash
  # and would trigger the NFS automount at boot before the network is up
  systemd.tmpfiles.settings.immich = lib.mkForce {};
}
