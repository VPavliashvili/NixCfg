{
  config,
  lib,
  osConfig,
  ...
}:
with lib; let
  cfg = osConfig.features.wms;
in {
  imports = [
    ./xorg
    ./wayland
  ];

  config = mkMerge [
    (mkIf (cfg.xorg.useWallpapers || cfg.wayland.useWallpapers) {
      home.file.".wallpapers" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/wallpapers";
        recursive = true;
      };
    })
  ];
}
