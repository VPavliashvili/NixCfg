{
  lib,
  config,
  ...
}: let
  cfg = config.virtualisation.sriov.vfio;
in {
  options.virtualisation.sriov.vfio.enable =
    lib.mkEnableOption "VFIO PCI-passthrough support";

  config = lib.mkIf cfg.enable {
    # Using VFIO requires to lock the memory that the passthrough device wants
    # to target for DMA transfers. This memory is typically the complete guest
    # physical address space.
    # Therefore, the userspace VMM application needs a memlock limit large
    # enough to lock the guest phyiscal memory. We simply give it unlimited
    # memlock capabilities.
    security.pam.loginLimits = [
      {
        domain = "*";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
    ];

    boot.kernelModules = ["vfio-pci"];
  };
}
