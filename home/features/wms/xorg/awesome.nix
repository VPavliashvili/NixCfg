{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; {
  config = mkIf (elem "awesomewm" osConfig.features.wms.enabled) {
    systemd.user.services.clipmenud = {
      Unit.Description = "clipmenu daemon";
      Service.ExecStart = "${pkgs.clipmenu}/bin/clipmenud";
      Install.WantedBy = ["graphical-session.target"];
    };

    # home.file.".config/awesome" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/awesome/.config/awesome";
    #   recursive = true;
    # };
    features.wms.xorg.launchParams.awesomewm = [
      "export PATH=\"$HOME/bin:$PATH\""
      "export XDG_SESSION_TYPE=x11"
      "export XDG_CURRENT_DESKTOP=awesome"
      "exec dbus-launch --exit-with-session startx /run/current-system/sw/bin/awesome"
    ];
  };
}
