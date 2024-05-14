{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, hyprland, nixpkgs-unstable, ... } @ inputs:
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
        # { programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland; }
        { programs.hyprland.package = inputs.nixpkgs-unstable.legacyPackages.${system}.hyprland; }
        ./system/configuration.nix
      ];
    };
    homeConfigurations.risus = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        # https://wiki.hyprland.org/hyprland-wiki/pages/Nix/Hyprland-on-Home-Manager/
        hyprland.homeManagerModules.default
        { programs.waybar.package = inputs.nixpkgs-unstable.legacyPackages.${system}.waybar; }
        ./home/home.nix
     ];
    };
  };
}
