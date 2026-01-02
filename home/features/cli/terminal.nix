{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = osConfig.features.wms.terminals;
in {
  config = lib.mkMerge [
    (
      lib.mkIf (lib.any (pkg: pkg.pname or pkg.name or "" == "foot") cfg.packages)
      {
        home.file.".config/foot" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/foot/.config/foot";
          recursive = true;
        };
      }
    )
    (
      lib.mkIf (lib.any (pkg: pkg.pname or pkg.name or "" == "wezterm") cfg.packages)
      {
        home.file.".config/wezterm" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/wezterm/.config/wezterm";
          recursive = true;
        };
      }
    )
  ];
}
