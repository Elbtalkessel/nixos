{
  description = "System configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://colmena.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];
  };

  inputs = {
    nixpkgs = {
      # nixos-24.05 for stable, nixos-unstable for unstable
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      # release-24.05 for stable, master for unstable
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-02b9 = {
      url = "github:nixos/nixpkgs/02b9ebc695596cdcd7d58b1180e1be4b0d6735f8";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    nixvim = {
      # Remove the branch name to switch to unstable
      url = "github:Elbtalkessel/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-custom = {
      url = "github:Elbtalkessel/nixpkgs-custom/master";
      inputs.nixpkgs.follows = "nixpkgs";
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
      nixpkgs-02b9,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixpkgs-custom.overlays.default
          # Downgrade devenv to version 1.6.1
          # https://github.com/cachix/devenv/pull/1992
          (_: _: {
            inherit (import nixpkgs-02b9 { inherit system; }) devenv;
          })
          (_: _: {
            neovim = nixvim.packages.${pkgs.system}.default;
          })
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
          ./options.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./system/omen.nix
        ];
      };

      # Non-NixOS machines with home-manager installed.
      homeConfigurations.virt = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./options.nix
          ./home/virt.nix
        ];
      };

      # Home configuration.
      homeConfigurations.risus = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./options.nix
          ./home/omen.nix
        ];
      };
    };
}
