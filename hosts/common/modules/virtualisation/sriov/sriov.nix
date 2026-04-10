# this and sibling ./vfio.nix is taken from
# https://github.com/cyberus-technology/nixos-sriov
# only difference is updated linux-intel-lts package from 6.6.15 to 6.12.28
# might pull request later
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.virtualisation.sriov.intel-graphics-sriov;
in {
  options.virtualisation.sriov.intel-graphics-sriov = {
    enable = lib.mkEnableOption "Enable Intel graphics SRIOV support";

    autoStart = lib.mkOption {
      description = "Start the SRIOV enablement service during boot";
      default = true;
      type = lib.types.bool;
    };

    deviceBDF = lib.mkOption {
      description = "The BDF of the Intel graphics device";
      default = "0000:00:02.0";
      type = lib.types.str;
    };
  };

  imports = [
    ./vfio.nix
  ];

  config = lib.mkIf cfg.enable {
    hardware.enableRedistributableFirmware = true;

    boot.kernelParams = [
      "intel_iommu=on"
      "i915.enable_guc=3"
      "i915.max_vfs=7"
      "module_blacklist=xe"
      "iommu=pt"
      "split_lock_detect=off"
    ];
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_19;
    boot.extraModulePackages = [pkgs.i915-sriov];

    virtualisation.sriov.vfio.enable = true;

    systemd.services.enableSriov = {
      description = "SRIOV Graphics card enablement";
      wantedBy = lib.mkIf cfg.autoStart ["graphical.target"];
      after = ["graphical.target"];
      path = with pkgs; [pciutils];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "enableSriov" ''
          deviceBDF=${cfg.deviceBDF}
          IFS=" " read -ra lspciString <<< "$(lspci -s $deviceBDF -n)"
          if [ "''${lspciString[1]}"=="0300" ]; then
            IFS=":" read -ra vendorDevice <<< "''${lspciString[2]}"
            echo '0' | tee -a /sys/bus/pci/devices/$deviceBDF/sriov_drivers_autoprobe
            echo '7' | tee -a /sys/bus/pci/devices/$deviceBDF/sriov_numvfs
            echo '1' | tee -a /sys/bus/pci/devices/$deviceBDF/sriov_drivers_autoprobe
            echo "''${vendorDevice[0]} ''${vendorDevice[1]}" | tee -a /sys/bus/pci/drivers/vfio-pci/new_id
            chmod 0666 /dev/vfio/*
          else
            echo "The Device at $deviceBDF is no Graphics Card"
          fi
        '';
      };
    };
  };
}
