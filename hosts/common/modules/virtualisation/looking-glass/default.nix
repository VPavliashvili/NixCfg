# this module installs kvmfr(kvm frame relay) kernle module
# from looking-glass source code and adds necessary kernel params and udev rules
# needed only for igpu sriov laptop
{ lib, pkgs, config, mainUser, ... }:
with lib;
let
  cfg = config.virtualisation.looking-glass;
in {
  options.virtualisation.looking-glass = {
    enable = mkEnableOption "enable looking glass";
    kvmfr = {
      enable = mkEnableOption "enable kvmfr module for looking-glass";
      size = mkOption {
        type = types.int;
        default = "64";
        description = "Size of the shared memory device in megabytes";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # kvmfr stuff
    boot.extraModulePackages = optionals cfg.kvmfr.enable (with config.boot.kernelPackages; [
      (pkgs.callPackage ./kvmfr-git-package.nix { inherit kernel;})
    ]);
    boot.initrd.kernelModules = optionals cfg.kvmfr.enable ([ "kvmfr" ]);
    boot.kernelParams = optionals cfg.kvmfr.enable ([
      "kvmfr.static_size_mb=${toString cfg.kvmfr.size}"
    ]);
    services.udev.extraRules = optionalString cfg.kvmfr.enable ''
      SUBSYSTEM=="kvmfr", OWNER="${mainUser}", GROUP="qemu-libvirtd", MODE="0666"
    '';

    #related packages
    environment.systemPackages = [
      pkgs.looking-glass-client
    ];
  };
}
