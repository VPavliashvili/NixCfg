{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
in {
  imports = [
    ./awesome.nix
  ];

  options.features.wms.xorg = {
    enabled = mkOption {
      # these enum values should be bash identifier friendly
      # no hyphens or any other weird stuff here
      # also, these are predefined options meaning they are only available
      # wms to choose from(on the host config side), not the ones will get installed necessarily
      type = types.listOf (types.enum ["none" "awesomewm"]);
      default = ["none"];
      description = "xorg window managers to install and make available for selection at login";
    };
    terminals = {
      packages = mkOption {
        type = types.listOf types.package;
        default = [pkgs.alacritty pkgs.wezterm pkgs.kitty pkgs.ghostty];
        description = "terminal emulators available under xorg wms";
      };
    };
    defaultTerms = mkOption {
      type = types.attrsOf types.str;
      default = {};
      internal = true;
      description = "Per-WM default terminal, populated by each window manager submodule";
    };
  };
}
