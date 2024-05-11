{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
  {
    # NixOS configuration per host
    nixosConfigurations.omen = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # The closest one to my laptop,
        # amp cpu + amd cpu pstate + amd gpu + nvidia + ssd
        nixos-hardware.nixosModules.omen-15-en0010ca
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
