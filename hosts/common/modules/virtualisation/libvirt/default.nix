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
      swtpm.enable = true;
      runAsRoot = false;
      verbatimConfig = if builtins.length cfg.deviceACL > 0 then ''
        clear_emulation_capabilities = 0
        cgroup_device_acl = [
          ${aclString}
        ]
      ''
      else ''
          clear_emulation_capabilities = 0
      '';
    };
  };

  config.environment.systemPackages = [
    pkgs.virt-manager
  ];

  # add this environment variable to avoid using sudo every time when writing virsh command
  config.environment.variables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };

  # this should solve `network 'default' is not active` error
  config.systemd.services.libvirt-default-network-autostart = {
    description = "Set libvirt 'default' network to autostart";
    after = [ "libvirtd.service" ];
    wants = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-autostart default";
    };
  };
}
