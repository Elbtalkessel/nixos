{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/master";
    nixvim.url = "github:Elbtalkessel/nixvim/custom";
  };

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , home-manager
    , nixvim
    ,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      packages = {
        usbdrivetools = import ./packages/usbdrivetools/default.nix { inherit pkgs; };
        bootdev = import ./packages/bootdev/default.nix { inherit pkgs; };
      };

      # System configuration
      # NixOS configuration per host
      nixosConfigurations.omen = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # The closest one to my laptop,
          # amp cpu + amd cpu pstate + amd gpu + nvidia + ssd
          nixos-hardware.nixosModules.omen-15-en0010ca
          ./system/configuration.nix
        ];
      };
      # -- System

      # Home configuration
      homeConfigurations.risus = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          {
            home.packages = [
              nixvim.packages.${system}.default
              self.packages.usbdrivetools
              self.packages.bootdev
            ];
          }

          ./home/home.nix
        ];
      };
      # -- Home
    };
}
