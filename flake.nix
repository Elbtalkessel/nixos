{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/master";
    nixvim.url = "github:Elbtalkessel/nixvim/custom";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      nixvim,
      disko,
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

      nixosConfigurations = {
        # Virtual machine, for testing, closely follows the main machine.
        virt = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            ./hw/virt-disko.nix
            ./hw/virt-configuration.nix
            ./system/configuration.nix
          ];
        };

        # Main machine configuration
        omen = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # The closest one to my laptop,
            # amp cpu + amd cpu pstate + amd gpu + nvidia + ssd
            nixos-hardware.nixosModules.omen-15-en0010ca
            disko.nixosModules.disko
            ./hw/disko.nix
            ./hw/configuration.nix
            ./system/configuration.nix
          ];
        };
      };

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
    };
}
