{
  description = "System configuration";

  inputs = {
    nixpkgs = {
      # nixos-24.05 for stable, nixos-unstable for unstable
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      # release-24.05 for stable, master for unstable
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      # Remove the branch name to switch to unstable
      url = "github:Elbtalkessel/nixvim";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    nixpkgs-custom = {
      url = "github:Elbtalkessel/nixpkgs-custom/master";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      nixpkgs-custom,
      nixos-hardware,
      disko,
      sops-nix,
    }:
    let
      system = "x86_64-linux";

      # Overlayed packages for home configuration.
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixpkgs-custom.overlays.default
        ];
      };

      # Builds an attribute set for a `name`,
      # where name is host-specific configuration inside hosts/ (without .nix).
      # All machine configurations have `nixos-hardware` module passed as
      # argument.
      baseMachine = name: {
        inherit name;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit nixos-hardware;
          };
          modules = [
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            ./hosts/${name}.nix
            ./system/configuration.nix
          ];
        };
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map baseMachine [
          "virt"
          "omen"
        ]
      );

      homeConfigurations.remote = home-manager.lib.homeManager {
        inherit pkgs;
        modules = [
          nixvim.packages.${pkgs.system}.default
          ./remote/home.nix
        ];
      };

      # Home configuration.
      homeConfigurations.risus = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.packages = [
              nixvim.packages.${pkgs.system}.default
              pkgs.usbdrivetools
              pkgs.bootdev
            ];
          }
          ./home/home.nix
        ];
      };
    };
}
