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
    ./awesome.nix
  ];

  options.features.wms.xorg = {
    launchParams = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "for each wm this will get filled with shell command sequence to launch its respective wm from the tty. As the type suggest this is map of sequence(list) of strings, which on their part will be bash commands"; # this a big ass description ik
    };
  };

  config = mkMerge [
    (mkIf cfg.notifications.useDunst {
      home.file.".config/dunst" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/dunst/.config/dunst";
        recursive = true;
      };
    })
  ];
}
