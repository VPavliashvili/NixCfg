{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: let
    kernel = final.linuxPackages.kernel;
  in
    import ../pkgs {
      inherit final kernel;
      pkgs = final;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # installing looking glass from overlay 
    # because I don't want this updated automatically
    # without my manual intervention
    looking-glass-client = import ./mods/looking-glass-client-B7.nix {inherit prev;};
    # roslyn-ls = import ./mods/roslyn-ls-latest {inherit prev;};
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
