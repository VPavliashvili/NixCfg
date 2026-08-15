{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms;
in {
  imports = [
    ./xorg
    ./wayland
  ];

  options.features.wms = {
    enabled = mkOption {
      type = types.listOf types.str;
      readOnly = true;
      description = "Window managers to enable(from wayland + xorg)";
    };
    notifications = {
      useDunst = mkEnableOption "install dunst";
    };
  };

  config = mkMerge [
    (mkIf cfg.notifications.useDunst {environment.systemPackages = [pkgs.dunst];})
    {
      environment.systemPackages =
        unique (cfg.wayland.terminals.packages ++ cfg.xorg.terminals.packages);
    }

    {
      # using unique because default 'none' might duplicate in both xorg and wayland modules
      features.wms.enabled = unique (
        filter (wm: wm != "none") (cfg.wayland.enabled ++ cfg.xorg.enabled)
      );
    }
  ];
}
