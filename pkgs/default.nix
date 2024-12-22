{ pkgs, kernel, ... }:
{
  # need this for ivshmem kernel module
  kvmfr = pkgs.callPackage ./kvmfr {inherit kernel;};
}
