{ config, pkgs, unstable, ... }: 
{ 
  imports = [ 
    ../common 
    ../features/cli
    ../features/misc
    ./home.nix
  ]; 

  features = {
    cli = {
      oh-my-posh.enable = true;
      bash.enable = true;
      zellij.enable = true;
      neovim.enable = true;
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
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
}
