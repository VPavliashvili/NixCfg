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
    ./hyprland.nix
    ./sway.nix
  ];

  options.features.wms.wayland = {
    launchParams = mkOption {
      type = types.listOf types.str;
      default = ["exec Hyprland"];
      description = "binary names to launch when starting the wm";
    };
  };

  config = mkMerge [
    (mkIf cfg.notifications.useDunst {
      home.file.".config/dunst" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dunst/.config/dunst";
        recursive = true;
      };
    })

    {
      home.file.".config/swappy" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/swappy/.config/swappy";
        recursive = true;
      };
    }
  ];
}
