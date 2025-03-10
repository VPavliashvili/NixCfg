{
  description = ''
    For questions just DM me on X: https://twitter.com/@m3tam3re
    There is also some NIXOS content on my YT channel: https://www.youtube.com/@m3tam3re

    One of the best ways to learn NIXOS is to read other peoples configurations. I have personally learned a lot from Gabriel Fontes configs:
    https://github.com/Misterio77/nix-starter-configs
    https://github.com/Misterio77/nix-config

    Please also check out the starter configs mentioned above.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sriov-modules = {
      url = "github:cyberus-technology/nixos-sriov";
      flake = false;
    };
  };

  outputs = { self, home-manager, nixpkgs, sriov-modules, ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      unstable = inputs.unstable.legacyPackages."x86_64-linux";
      sriovModules = sriov-modules;
    in {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        parthGalen = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs unstable sriovModules; };
          modules = [
            ./hosts/parthGalen 

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stranger = import ./home/stranger/parthGalen.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                outputs = outputs;
              };
            }
          ];
        };
        dorthonion = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs unstable; };
          modules = [
            ./hosts/dorthonion 

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stranger = import ./home/stranger/dorthonion.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                outputs = outputs;
              };
            }
          ];
        };
      };
    };
}
