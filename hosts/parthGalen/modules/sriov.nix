{ config, pkgs, unstable, sriovModules, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      (import "${sriovModules}/sriov.nix")
    ];

  # copied from https://cyberus-technology.de/en/articles/simplify-your-sr-iov-setup-a-guide-to-nixos-modules-and-specializations
  specialisation.vbox-kvm-sriov.configuration = {
    virtualisation.cyberus.intel-graphics-sriov.enable = true;
    virtualisation.virtualbox.host = {
      enable = true;
      enableKvm = true;
      enableHardening = false;
      addNetworkInterface = false;
    };
  };
}
