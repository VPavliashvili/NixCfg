{ lib, config, osConfig, ... }:
with lib;
{
  config = mkIf (osConfig.features.wms.wm == "sway") {
    home.file.".config/sway" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/sway/.config/sway";
      recursive = true;
    };
    features.wms.wayland.launchParams = [
      "export QT_QPA_PLATFORM=wayland"
      "export MOZ_ENABLE_WAYLAND=1"
      "export MOZ_WEBRENDER=1"
      "export XDG_SESSION_TYPE=wayland"
      "export XDG_CURRENT_DESKTOP=sway"
      "exec sway"
    ];
  };
}
