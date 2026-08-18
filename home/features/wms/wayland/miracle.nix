{
  lib,
  config,
  osConfig,
  ...
}:
with lib; {
  config = mkIf (osConfig.features.wms.wayland.miracle.enable) {
    home.file.".config/miracle-wm" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/miracle-wm/.config/miracle-wm";
      recursive = true;
    };
    features.wms.wayland.launchParams.miracle = [
      "export QT_QPA_PLATFORM=wayland"
      "export MOZ_ENABLE_WAYLAND=1"
      "export MOZ_WEBRENDER=1"
      "export ELECTRON_OZONE_PLATFORM_HINT=auto"

      "export XDG_SESSION_TYPE=wayland"
      "export XDG_CURRENT_DESKTOP=miracle-wm"

      "exec miracle-wm"
    ];
  };
}
