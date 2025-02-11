{
  description = "System configuration";

  inputs = {
    # nixos-24.05 for stable, nixos-unstable for unstable
    nixpkgs = {
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
      url = "github:Elbtalkessel/nixvim/custom";
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
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixpkgs-custom.overlays.default
        ];
      };
    in
    {
      nixosConfigurations = {
        # Virtual machine, for testing, closely follows the main machine.
        virt = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/virt.nix
            ./system/configuration.nix
          ];
        };

        # Main machine configuration
        omen = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/omen.nix
            ./system/configuration.nix
          ];
        };
      };

      # Home configuration
      homeConfigurations.risus = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.packages = [
              nixvim.packages.${system}.default
              pkgs.usbdrivetools
              pkgs.bootdev
            ];
          }

          ./home/home.nix
        ];
      };
    };
}
