{
  lib,
  config,
  osConfig,
  ...
}:
with lib; {
  config = mkIf (osConfig.features.wms.wayland.mango.enable) {
    home.file.".config/mango" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/mango/.config/mango";
      recursive = true;
    };
    # home.file.".config/mango-waybar" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/mango/.config/waybar";
    #   recursive = true;
    # };

    features.wms.wayland.launchParams.mango = [
      "exec mango"
    ];
  };
}
