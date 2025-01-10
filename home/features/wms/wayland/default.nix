{config, lib, ...}: 
with lib;
{
  imports = [
    ./hyprland.nix
    ./sway.nix
  ];

  options.features.wms.wayland = {
    launchParams = mkOption {
      type = types.listOf types.str;
      default = [ "exec Hyprland" ];
      description = "binary names to launch when starting the wm";
    };
  };
}
