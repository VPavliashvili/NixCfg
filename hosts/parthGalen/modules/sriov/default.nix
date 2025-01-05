{ lib, pkgs, config, sriovModules, ... }: 
with lib;
let
  cfg = config.virtualisation.sriov;

in {
  imports = [
    (import "${sriovModules}/sriov.nix")
  ];

  options.virtualisation.sriov = {
    enable = mkEnableOption "enable sriov support for igpu and add boot option with specific kernel";
  };

  config.specialisation = lib.mkIf cfg.enable {
    "SR-IOV".configuration = {
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
  };
}
