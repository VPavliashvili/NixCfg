{ lib, pkgs, config, ... }:
with lib;
let 
    cfg = config.virtualisation.libvirtd;
    aclString = with lib.strings;
        concatMapStringsSep ''
          ,
            '' escapeNixString cfg.deviceACL;
in {
  options.virtualisation.libvirtd = {
    deviceACL = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config.users.users."qemu-libvirtd" = {
    group = "qemu-libvirtd";
    extraGroups =  [ "kvm" "input" ];
    isSystemUser = true;
  };

  config.virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
      swtpm.enable = true;
      runAsRoot = false;
      verbatimConfig = ''
        clear_emulation_capabilities = 0
        cgroup_device_acl = [
          ${aclString}
        ]
      '';
    };
  };
}
