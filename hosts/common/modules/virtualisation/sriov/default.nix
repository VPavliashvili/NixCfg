{ lib, pkgs, config, ... }: 
with lib;
let
  cfg = config.virtualisation.sriov;

in {
  imports = [
    ./sriov.nix
  ];

  options.virtualisation.sriov = {
    enable = mkEnableOption "enable sriov support for igpu and add boot option with specific kernel";
  };

  config.specialisation = mkIf cfg.enable {
    "SR-IOV".configuration = {
      config.system.nixos.tags = [ "SR-IOV" ];

      config.virtualisation.sriov.intel-graphics-sriov.enable = true;
    };
  };
}
