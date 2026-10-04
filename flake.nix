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
      url = "git+https://codeberg.org/outlast/nixvim?ref=main";
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
    # Takes no nixpkgs input, so there is nothing here to follow.
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-skills = {
      url = "github:olafkfreund/nix-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      # Every host here is Linux on Intel. Add an attrset of per-system
      # configurations rather than widening this string if that ever changes.
      system = "x86_64-linux";

      # Shared by both trees, so that no module has to reach outside its own
      # directory to name a path. The flake root is the only stable anchor.
      sopsModule = {
        sops.defaultSopsFile = ./secrets/secrets.yaml;
        sops.defaultSopsFormat = "yaml";
      };

      # Overlays both trees need. A module, not a package set built here: a
      # tree handed a pre-built `pkgs` ignores `nixpkgs.overlays` and
      # `nixpkgs.config` entirely, which is also what forced the unfree
      # allowlist into a central predicate before. See the module for details.
      nixpkgsModule = ./modules/common/nixpkgs.nix;

      # One entry per host. `dir` is the host directory holding `nixos.nix`,
      # `home.nix` and `disko.nix`; `user` names the home-manager configuration,
      # so it is the key under `homeConfigurations`, not the host name.
      #
      #   sops  whether this host reads secrets. It gates `sopsModule` in both
      #        trees; a host that decrypts nothing opts out, which is what
      #        keeps the virt example self-contained.
      #
      # Nothing else belongs here. Hardware, disk layout, state version and
      # module selection are host concerns and live in `dir/nixos.nix` and
      # `dir/home.nix`.
      hosts = {
        # The workstation. Shares no modules with atlas or virt: the shared
        # ones are written against its hardware.
        omen = {
          dir = ./hosts/omen;
          user = "risus";
          sops = true;
        };

        # atlas: a headless VM that runs opencode. Unlike virt it reads secrets
        # -- the shared login password on the system side, the Gitea MCP token
        # on the home side -- so both trees get sopsModule.
        atlas = {
          dir = ./hosts/atlas;
          user = "atlas";
          sops = true;
        };

        # A second host, kept deliberately minimal, and the only one that reads
        # no secrets at all.
        virt = {
          dir = ./hosts/virt;
          user = "virt";
          sops = false;
        };
      };

      # Both trees get the same two shared roots -- `nixpkgsModule` and the
      # `my.*` namespace -- so a setting added to either is available to both
      # without the flake having to know what it is.
      sharedModules =
        host:
        [
          nixpkgsModule
          ./options
        ]
        ++ lib.optional host.sops sopsModule;

      nixosFor =
        host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = sharedModules host ++ [ (host.dir + "/nixos.nix") ];
        };

      homeFor =
        host:
        home-manager.lib.homeManagerConfiguration {
          # `pkgs` is a required argument, but home-manager only reads `config`
          # and `overlays` off it and then re-imports nixpkgs from
          # `nixpkgs.pkgsPath` with whatever `nixpkgs.*` the modules set. A bare
          # package set is therefore not a shortcut around the module system, it
          # is the way to leave `nixpkgs.overlays` and `nixpkgs.config` working
          # inside this tree.
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = inputs;
          modules = sharedModules host ++ [ (host.dir + "/home.nix") ];
        };
    in
    {
      # The callback needs *two* parameters: `lib.mapAttrs` passes name and value,
      # and a one-parameter `name: nixosFor (...)` would leave Nix applying the
      # value to the returned configuration. `lib.mapAttrs'` is the opposite
      # contract -- it wants `nameValuePair`s -- which is what re-keying the hosts
      # by user name below needs.
      nixosConfigurations = lib.mapAttrs (_name: _: nixosFor hosts.${_name}) hosts;

      homeConfigurations = lib.mapAttrs' (_name: host: lib.nameValuePair host.user (homeFor host)) hosts;
    };
}
