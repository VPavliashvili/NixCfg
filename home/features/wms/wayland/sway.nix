{ lib, config, osConfig, ... }:
with lib;
{
  config = mkIf (osConfig.features.wms.wm == "sway") {
    home.file.".config/sway" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/sway/.config/sway";
      recursive = true;
    };
    features.wms.wayland.launchParams = [
      # setting bemoji picker to fuzzel
      # in case of hyprland its getting set from hyprland conf
      # but sway does not have such capability
      # so here we are setting bemoji picker at startup
      "export BEMOJI_PICKER_CMD='fuzzel -b 282c34ff -t 61afefff -s 98c379ff -m c678ddff -S 000000ff -f SourceCodePro:size=12 -i -w 50 -l 25 --dmenu'"

      "export QT_QPA_PLATFORM=wayland"
      "export MOZ_ENABLE_WAYLAND=1"
      "export MOZ_WEBRENDER=1"
      "export XDG_SESSION_TYPE=wayland"
      "export XDG_CURRENT_DESKTOP=sway"
      "exec sway"
    ];
  };
}
