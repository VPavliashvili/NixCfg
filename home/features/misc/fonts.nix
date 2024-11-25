{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.misc.fonts;
in {
  options.features.misc.fonts.enable = lib.mkEnableOption "installs essential fonts sufficient for everything";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      noto-fonts                                                                                           
      noto-fonts-cjk                                                                                       
      noto-fonts-emoji                                                                                     
      liberation_ttf
      nerdfonts
      roboto-mono
      font-awesome
    ];
  };
}
