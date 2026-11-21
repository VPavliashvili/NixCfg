{
  lib,
  pkgs,
  config,
  unstable,
  ...
}: {
  imports = [
    ./tooling.nix
    ./claude-jailed.nix
  ];
}
