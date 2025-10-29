{
  pkgs,
  config,
  lib,
  unstable,
  ...
}:
let
  cfg = config.features.cli.zellij;
in {
  options.features.cli.zellij.enable = lib.mkEnableOption "enable zellij multiplexer";

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      package = unstable.zellij;
    };
    
    home.packages = [
      pkgs.zellij-switch
    ];

    home.file.".config/zellij" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/zellij/.config/zellij";
      recursive = true;
    };

    # this fixes the issue when zellij can't execute plugin installed as nix package
    home.activation.copyZellijPlugin = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $HOME/.config/zellij/plugins
      $DRY_RUN_CMD ln -sf ${pkgs.zellij-switch}/bin/zellij-switch.wasm $HOME/.config/zellij/plugins/zellij-switch.wasm
    '';
  };
}
