{
  lib,
  pkgs,
  config,
  ...
}: {
  # the code below only works for intel hardware
  config = {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # Add jellyfin user to render group for hardware access
    users.users.jellyfin.extraGroups = ["render" "video"];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-ocl
        intel-media-driver
        intel-compute-runtime-legacy1
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
    systemd.services.jellyfin.environment = {
      LIBVA_DRIVER_NAME = "iHD";
      LIBVA_DRIVERS_PATH = "${pkgs.intel-media-driver}/lib/dri";
    };
  };
}
