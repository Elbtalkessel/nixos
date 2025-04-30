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
      nixpkgs,
      home-manager,
      nixvim,
      nixpkgs-custom,
      nixos-hardware,
      disko,
      sops-nix,
      ...
    }:
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
      nixosConfigurations.omen = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit nixos-hardware;
        };
        modules = [
          { nixpkgs = { inherit pkgs; }; }
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./system/omen.nix
        ];
      };

      # Non-NixOS machines with home-manager installed.
      homeConfigurations.virt = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.packages = [
              nixvim.packages.${pkgs.system}.default
            ];
          }
          ./home/virt.nix
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
          ./home/omen.nix
        ];
      };
    };
}
