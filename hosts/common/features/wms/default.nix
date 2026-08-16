{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms;
  xorgActive = cfg.xorg.enabled;
  waylandActive = cfg.wayland.enabled;
in {
  imports = [
    ./xorg
    ./wayland
  ];

  options.features.wms = {
    notifications = {
      useDunst = mkEnableOption "install dunst";
    };
  };

  config = mkMerge [
    (mkIf cfg.notifications.useDunst {environment.systemPackages = [pkgs.dunst];})
    {
      environment.systemPackages = unique (
        optionals xorgActive cfg.xorg.terminals.packages
        ++ optionals waylandActive cfg.wayland.terminals.packages
      );
    }
  ];
}
