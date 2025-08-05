{ lib, config, pkgs, unstable, osConfig, ... }: 
{ 
  imports = [ 
    ../../features/cli
    ../../features/gui
    ../../features/misc
    ../../features/wms/wayland
    ./home.nix
  ]; 

  features = {
    cli = {
      oh-my-posh.enable = true;
      bash.enable = true;
      zellij.enable = true;
    };
    misc = {
      fonts.enable = true;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue-Dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
