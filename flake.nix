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
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      nixvim,
      disko,
      sops-nix,
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
            ./hosts/virt.nix
            ./system/configuration.nix
          ];
        };

        # Main machine configuration
        omen = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Mostly from https://github.com/NixOS/nixos-hardware/blob/master/omen/16-n0280nd/default.nix
            # The rest (kernel modules and prime config is in the omen.nix)
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-gpu-nvidia
            nixos-hardware.nixosModules.common-pc-laptop
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            ./hosts/omen.nix
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
