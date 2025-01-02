{ pkgs, config, sriovModules, ... }: {
  imports = [
    (import "${sriovModules}/sriov.nix")
  ];

  specialisation."SR-IOV".configuration = {
    config.system.nixos.tags = [ "SR-IOV" ];

    # copied from https://cyberus-technology.de/en/articles/simplify-your-sr-iov-setup-a-guide-to-nixos-modules-and-specializations
    config.virtualisation.cyberus.intel-graphics-sriov.enable = true;
    config.virtualisation.virtualbox.host = {
      enable = true;
      enableKvm = true;
      enableHardening = false;
      addNetworkInterface = false;
    };
  };
}
