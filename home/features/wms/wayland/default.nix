{
  config,
  lib,
  osConfig,
  ...
}:
with lib; let
  cfg = osConfig.features.wms;

  gpuCfg = cfg.wayland.devices.gpu;
  gpuPath = role: "/dev/dri/wayland-${role}-gpu";
  gpuDrms =
    if gpuCfg.primary == null
    then null
    else if gpuCfg.secondary == null
    then gpuPath "primary"
    else "${gpuPath "primary"}:${gpuPath "secondary"}";
in {
  imports = [
    ./hyprland.nix
    ./sway.nix
    ./mango.nix
    ./miracle.nix
  ];

  options.features.wms.wayland = {
    launchParams = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "for each wm this will get filled with shell command sequence to launch its respective wm from the tty. As the type suggest this is map of sequence(list) of strings, which on their part will be bash commands"; # this a big ass description ik
    };
    gpuDevices = mkOption {
      type = types.nullOr types.str;
      internal = true;
      readOnly = true;
      default = gpuDrms;
      description = "internal variable inside config for gpu device setting per wayland wm";
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
