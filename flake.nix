{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/master";
    nixvim.url = "git+file:///home/risus/nix/nixvim";
  };

  outputs = inputs: let
    system = "x86_64-linux";
  in {
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
        config.allowUnfree = true;
      };
      modules = [
        {home.packages = [inputs.nixvim.packages.${system}.default];}
        ./home/home.nix
      ];
    };
  };
}
