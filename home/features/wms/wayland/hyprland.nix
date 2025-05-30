{ config, osConfig, lib, ... }:
with lib;
{
  config = mkIf (osConfig.features.wms.wm == "hyprland") {
    # this line is to delete ./config/hypr directory if it exists
    # which is autogenerated by hyprlands stupid behaviour
    # and gets in the way of home-manager to create its own hypr symlink successfully
    home.activation.removeHyprConfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.config/hypr
    '';

    home.file.".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/hypr";
      recursive = true;
    };

    features.wms.wayland.launchParams = [ "exec Hyprland" ];
  };
}
