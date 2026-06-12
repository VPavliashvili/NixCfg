{
  config,
  pkgs,
  mainUser,
  allowedHosts,
  lib,
  ...
}: {
  options.modules.networking = {
    testingTools = lib.mkEnableOption "cli tools for networking testing";
  };

  config = lib.mkIf config.modules.networking.testingTools {
    environment.systemPackages = with pkgs; [iperf3];
    networking.firewall.allowedTCPPorts = [5201];
  };
}
