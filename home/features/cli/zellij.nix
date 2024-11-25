{
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
  };
}
