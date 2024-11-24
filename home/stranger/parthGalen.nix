{ config, pkgs, unstable, ... }: 
{ 
  imports = [ ./home.nix ../common ]; 

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
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

  programs.git = {
      enable = true;
      userName = "VPavliashvili";
      userEmail = "v_pavliashvili@yahoo.com";
      aliases = {
          graph = "log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --all --graph --date=relative";
          lgraph = "log --pretty='%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s' --all --decorate --graph";
      };
  };


  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    package = unstable.oh-my-posh;
    # settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./dots/oh-my-posh/my-custom.omp.json));
  };

  programs.zellij = {
      enable = true;
      package = unstable.zellij;
  };

  programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
          neofetch = "fastfetch";
      };
      initExtra = ''
          alias luamake="$HOME/lua-language-server/3rd/luamake/luamake"
          export LUA_CPATH="/usr/share/lua/5.4/?.so;"
          export PATH="$HOME/bin:$PATH"
          export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
          export PATH="$HOME/go/bin:$PATH"
          export GPG_TTY=$(tty)
          export XDG_SCREENSHOTS_DIR=$HOME/Pictures/Screenshots
          export GRIM_DEFAULT_DIR=$HOME/Pictures/Screenshots

          set -o vi
          bind -m vi-command 'Control-l: clear-screen'
          bind -m vi-insert 'Control-l: clear-screen' 
      '';
  };
}
