{
  description = "System configuration";

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
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
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
    # https://determinate.systems/blog/nuenv/
    nuenv = {
      url = "https://flakehub.com/f/xav-ie/nuenv/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      nixpkgs-custom,
      disko,
      sops-nix,
      nuenv,
      ...
    }@attrs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # List of unfree packages you're ok to have.
        config.allowUnfreePredicate =
          pkg:
          let
            name = pkgs.lib.getName pkg;
          in
          (builtins.elem name [
            # From the home manager config.
            "vagrant"
            "jetbrains-toolbox"
            # From the system config.
            "nvidia-x11"
            "nvidia-settings"
            "nvidia-kernel-modules"
            "steam"
            "steam-unwrapped"
            # cuda | llm
            "libcublas"
            "open-webui"
          ])
          || pkgs.lib.hasPrefix "cuda" name;
        overlays = [
          nixpkgs-custom.overlays.default
          nuenv.overlays.default
          (_: _: {
            neovim = nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
          })
        ];
      };
    in
    {
      nixosConfigurations.omen = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [
          { nixpkgs = { inherit pkgs; }; }
          ./options
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./system/omen.nix
        ];
      };

      # Non-NixOS machines with home-manager installed.
      homeConfigurations.virt = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./options
          ./home/virt.nix
        ];
      };

      # Home configuration.
      # Reference: https://nix-community.github.io/home-manager/options.xhtml#opt-<dot.notated.path.to.option>
      homeConfigurations.risus = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = attrs;
        modules = [
          ./options
          ./home/omen.nix
        ];
      };
    };
}
