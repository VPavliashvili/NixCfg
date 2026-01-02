{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = osConfig.features.wms.terminals;
in {
  config = lib.mkIf (lib.any (pkg: pkg.pname or pkg.name or "" == "foot") cfg.packages) {
    home.file.".config/foot" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/foot/.config/foot";
      recursive = true;
    };
  };
}
