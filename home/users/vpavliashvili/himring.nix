{ lib, config, pkgs, unstable, ... }: 
{ 
  imports = [ 
    ../../features/cli
    ../../features/misc
    ./home.nix
  ]; 

  features = {
    cli = {
      oh-my-posh.enable = true;
      bash.enable = true;
      zellij.enable = true;
      git = {
        name = "Vakhtang Pavliashvili";
        email = "v.pavliashvili@lb.ge";
        useSshSign = false;
      };
    };
    misc = {
      fonts.enable = true;
    };
  };
}
