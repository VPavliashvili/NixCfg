{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.virtualisation.vfio;
in {
  options.virtualisation.vfio = {
    enable = mkEnableOption "VFIO Configuration";
    devices = mkOption {
      type = types.listOf (types.strMatching "[0-9a-f]{4}:[0-9a-f]{4}");
      default = [ ];
      example = [ "10de:1b80" "10de:10f0" ];
      description = "PCI IDs of devices to bind to vfio-pci";
    };
    disableEFIfb = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Disables the usage of the EFI framebuffer on boot.";
    };
    ignoreMSRs = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description =
        "When true, disable kvm guest access to model-specific registers";
    };
    disablePCIeASPM = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description =
        "When true, disable PCIe Active-State Power Management";
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';

    boot.kernelParams = [
      "intel_iommu=on"
      "iommu=pt" 
      "i915.enable_guc=3" 
      "i915.max_vfs=7"
    ];

    boot.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
    boot.initrd.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
  };
}
