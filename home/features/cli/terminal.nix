{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  cfg = osConfig.features.wms;
  packages = lists.unique (cfg.wayland.terminals.packages ++ cfg.xorg.terminals.packages);
in {
  config = lib.mkMerge [
    (
      lib.mkIf (lib.any (pkg: pkg.pname or pkg.name or "" == "foot") packages)
      {
        home.file.".config/foot" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/foot/.config/foot";
          recursive = true;
        };
      }
    )
    (
      lib.mkIf (lib.any (pkg: pkg.pname or pkg.name or "" == "wezterm") packages)
      {
        home.file.".config/wezterm" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/wezterm/.config/wezterm";
          recursive = true;
        };
      }
    )
  ];
}
