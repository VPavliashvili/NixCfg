{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; {
  config = mkIf (elem "awesomewm" osConfig.features.wms.enabled) {
    # home.file.".config/awesome" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/awesome/.config/awesome";
    #   recursive = true;
    # };
    features.wms.xorg.launchParams.awesome = [
      "export PATH=\"$HOME/bin:$PATH\""
      "export XDG_SESSION_TYPE=x11"
      "export XDG_CURRENT_DESKTOP=awesome"
      "exec ${pkgs.dbus}/bin/dbus-launch --exit-with-session ${pkgs.xinit}/bin/startx ${pkgs.awesome}/bin/awesome"
    ];
  };
}
