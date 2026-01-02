{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = osConfig.features.cli;
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.btop {
      home.file.".config/btop" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/btop/.config/btop";
        recursive = true;
      };
    })
    (lib.mkIf cfg.yazi {
      home.file.".config/yazi" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/yazi/.config/yazi";
        recursive = true;
      };
    })
  ];
}
