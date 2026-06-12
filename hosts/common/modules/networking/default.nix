{
  config,
  pkgs,
  mainUser,
  allowedHosts,
  lib,
  ...
}: {
  imports = [
    ../networking/caddy.nix
    ../networking/testing.nix
  ];
}
