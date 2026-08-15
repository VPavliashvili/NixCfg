{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.wms;
in {
  options.features.wms.wayland.hyprland = {
    hy3.enable = mkEnableOption "use hy3 plugin for i3/sway like window management instead of builtin one";
    terminals.defaultTerm = mkOption {
      type = types.enum ["foot" "wezterm" "kitty" "ghostty"];
      default = "foot";
      description = "default terminal emulator under Hyprland";
    };
  };

  config = mkIf (elem "hyprland" cfg.enabled) {
    features.wms.wayland.defaultTerms.hyprland = cfg.wayland.hyprland.terminals.defaultTerm;

    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
    };
    environment.systemPackages =
      [
        pkgs.hyprland-per-window-layout
        pkgs.swappy
        pkgs.yad
        pkgs.fuzzel
        pkgs.cliphist
        pkgs.wl-clipboard
        pkgs.grim
        pkgs.slurp
        pkgs.wev
        pkgs.hyprlock
        pkgs.waybar
        pkgs.bemoji
        pkgs.hyprpaper
        pkgs.hyprpolkitagent
      ]
      ++ (optionals cfg.hyprland.hy3.enable [
        pkgs.hyprlandPlugins.hy3
      ]);
  };
}
