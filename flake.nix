{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
  {
    # NixOS configuration per host
    nixosConfigurations.omen = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # The closest one to my laptop,
        # amp cpu + amd cpu pstate + amd gpu + nvidia + ssd
        inputs.nixos-hardware.nixosModules.omen-15-en0010ca
        ./system/configuration.nix
      ];
    };
    homeConfigurations.risus = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      modules = [
        inputs.nixvim.homeManagerModules.nixvim 
        ./home/home.nix
     ];
    };
  };
}
