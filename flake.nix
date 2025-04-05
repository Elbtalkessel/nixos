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
    stable-diffusion-webui-nix = {
      url = "github:Janrupf/stable-diffusion-webui-nix/main";
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
      stable-diffusion-webui-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "cuda_cudart"
            "libcublas"
            "libcufft"
            "libcurand"
            "libcusolver"
            "libnvjitlink"
            "libcusparse"
            "libnpp"
            "cuda_cccl"
            "cuda_nvcc"
            "cuda_cuobjdump"
            "cuda_gdb"
            "cuda_nvdisasm"
            "cuda_nvprune"
            "cuda_cupti"
            "cuda_cuxxfilt"
            "cuda_nvrtc"
            "cuda_nvtx"
            "cuda_profiler_api"
            "cuda_sanitizer_api"
            "cuda_nvml_dev"
            "cuda-merged"
            "nvidia-x11"
            "nvidia-settings"
            "slack"
            "jetbrains-toolbox"
          ];
        overlays = [
          nixpkgs-custom.overlays.default
          stable-diffusion-webui-nix.overlays.default
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
          ./hosts/omen.nix
          ./system/configuration.nix
        ];
      };

      # Non-NixOS machines with home-manager installed.
      homeConfigurations.remote = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.packages = [
              nixvim.packages.${pkgs.system}.default
            ];
          }
          ./remote/home.nix
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
          ./home/home.nix
        ];
      };
    };
}
