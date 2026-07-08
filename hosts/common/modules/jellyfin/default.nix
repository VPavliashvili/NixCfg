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

    # add jellyfin user to render group for hardware and media library access
    users.users.jellyfin.extraGroups = ["render" "video" "media"];

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
