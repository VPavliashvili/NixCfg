{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms;
in {
  options.features.wms.wayland.sway = {
    terminals.defaultTerm = mkOption {
      type = types.enum ["foot" "wezterm" "kitty" "ghostty"];
      default = "foot";
      description = "default terminal emulator under sway";
    };
  };

  config = mkIf (elem "sway" cfg.enabled) {
    features.wms.wayland.defaultTerms.sway = cfg.wayland.sway.terminals.defaultTerm;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
    environment.systemPackages = [
      pkgs.swaykbdd
      pkgs.swaybg
      pkgs.swappy
      pkgs.bemoji
      pkgs.yad
      pkgs.fuzzel
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.grim
      pkgs.slurp
      pkgs.wev
      pkgs.swaylock-effects
      pkgs.waybar
    ];
  };
}
