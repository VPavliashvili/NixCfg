{ lib, pkgs, config, ... }:
{
  config = {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      (pkgs.callPackage ./kvmfr-git-package.nix { inherit kernel;})
    ];
    boot.initrd.kernelModules = [ "kvmfr" ];

    boot.kernelParams = [
      "kvmfr.static_size_mb=64"
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="kvmfr", OWNER="stranger", GROUP="qemu-libvirtd", MODE="0666"
    '';
  };
}
