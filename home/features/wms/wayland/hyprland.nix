# this only resolves hyprland configuration
# actual package is installed from configuration.nix on a host level
{
  config,
  lib,
  unstable,
  pkgs,
  ...
}:
let
  cfg = config.features.wms.wayland.hyprland;
in {
  options.features.wms.wayland.hyprland.enable = lib.mkEnableOption "enable hyprland compositor";

  config = lib.mkIf cfg.enable {
    home.file.".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/hypr";
      recursive = true;
    };
  };
}
