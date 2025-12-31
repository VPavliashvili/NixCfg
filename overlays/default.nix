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

    # since roslyn-ls from stable and unstable branches(version 25.05)
    # requires dotnet_9, I am willing to stay on dotnet 8 before 10 cames out
    # so gotta install this overlay to make roslyn-ls compatible to dotnet 8
    roslyn-ls = import ./mods/roslyn-ls-net8-compatible {inherit prev;};

    zellij-switch = (inputs.zellij-switch.overlays.default final prev).zellij-switch;
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
