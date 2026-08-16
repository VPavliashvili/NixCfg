{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; let
  awesomeSession = pkgs.writeShellScript "awesome-session" ''
    systemctl --user import-environment DISPLAY XAUTHORITY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP PATH
    systemctl --user start nixos-fake-graphical-session.target

    ${pkgs.awesome}/bin/awesome
    ec=$?

    systemctl --user stop nixos-fake-graphical-session.target
    exit $ec
  '';
in {
  config = mkIf (osConfig.features.wms.xorg.awesome.enable) {
    home.file.".config/awesome" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/awesome/.config/awesome";
      recursive = true;
    };
    features.wms.xorg.launchParams.awesome = [
      "export PATH=\"$HOME/bin:$PATH\""
      "export XDG_SESSION_TYPE=x11"
      "export XDG_CURRENT_DESKTOP=awesome"
      "exec ${pkgs.dbus}/bin/dbus-launch --exit-with-session ${pkgs.xinit}/bin/startx ${awesomeSession}"
    ];
  };
}
