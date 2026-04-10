{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  imports = [
    ./sriov.nix
  ];

  config.virtualisation.sriov.intel-graphics-sriov.enable = true;
}
