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
      url = "git+https://codeberg.org/outlast/nixpkgs?ref=master";
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

      # Overlays both trees need. A module, not a package set built here: a
      # tree handed a pre-built `pkgs` ignores `nixpkgs.overlays` and
      # `nixpkgs.config` entirely, which is also what forced the unfree
      # allowlist into a central predicate before. See the module for details.
      nixpkgsModule = ./modules/common/nixpkgs.nix;

      # One entry per host. `dir` is the host directory holding `nixos.nix`,
      # `home.nix` and `disko.nix`.
      hosts = {
        omen = {
          dir = ./hosts/omen;
          user = "risus";
          sops = true;
        };

        atlas = {
          dir = ./hosts/atlas;
          user = "atlas";
          sops = true;
        };

        virt = {
          dir = ./hosts/virt;
          user = "virt";
          sops = false;
        };
      };

      # Per-host sops settings shared by both trees: a per-tree module that
      # pulls in the matching `sops.*Modules.sops` and points the tree at
      # `./hosts/<name>/secrets.yaml` plus the single keyfile path
      # `/etc/sops-nix/key.txt`.
      #
      # The keyfile is read by two different processes on the same host: the
      # systemd `sops-install-secrets` activation unit (root) on the system
      # tree, and the user's `sops-nix.service` (running as the user) on the
      # home tree. `home-manager switch` invokes the latter without sudo. So
      # the file's perms have to be readable by the user account, not just by
      # root.
      #
      # Two conditions make this reliable:
      #   1. A dedicated `sops` system group is created and the host's user
      #      (`flake.nix`'s `hosts.<name>.user`) is added to it. The keyfile
      #      is then `root:sops 0640` and only the user account (and root)
      #      can read it.
      #   2. The `F` tmpfiles rule (capital F) re-applies mode + owner on
      #      every boot, so even a manual `cp` or `install` that landed 0600
      #      gets corrected at the next activation. `F` is safe on an existing
      #      non-empty file: it sets ownership and mode without truncating.
      #
      # `sops.environment.SOPS_AGE_KEY_FILE = "/etc/sops-nix/key.txt"` makes
      # the key path visible to subprocesses the activation spawns (notably
      # the `sops` binary itself). The system's manifest-based mechanism
      # already passes the key via `-ignore-passwd ${manifest}` to the home
      # side; this export is mostly for shell-driven `sops` use after first
      # boot.
      getSopsConfig =
        name: host:
        let
          # "/etc/sops-nix/key.txt"
          keyFile = "/home/${host.user}/.config/sops/age/keys.txt";
        in
        {
          defaultSopsFile = ./hosts/${name}/secrets.yaml;
          defaultSopsFormat = "yaml";
          age.keyFile = keyFile;
          environment.SOPS_AGE_KEY_FILE = keyFile;
        };
      sopsSharedSystem =
        name: host:
        lib.optional host.sops {
          imports = [ inputs.sops-nix.nixosModules.sops ];
          sops = getSopsConfig name host;
          systemd.tmpfiles.rules = [
            "F /etc/sops-nix/key.txt 0640 root sops - - -"
          ];
          users.groups.sops = { };
          users.users.${host.user}.extraGroups = [ "sops" ];
        };

      sopsSharedHome =
        name: host:
        lib.optional host.sops {
          imports = [ inputs.sops-nix.homeManagerModules.sops ];
          sops = getSopsConfig name host;
        };

      nixosSharedModules =
        name: host:
        [
          nixpkgsModule
          ./options
        ]
        ++ sopsSharedSystem name host;

      homeSharedModules =
        name: host:
        [
          nixpkgsModule
          ./options
        ]
        ++ sopsSharedHome name host;

      nixosFor =
        name: host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = nixosSharedModules name host ++ [ (host.dir + "/nixos.nix") ];
        };

      homeFor =
        name: host:
        home-manager.lib.homeManagerConfiguration {
          # `pkgs` is a required argument, but home-manager only reads `config`
          # and `overlays` off it and then re-imports nixpkgs from
          # `nixpkgs.pkgsPath` with whatever `nixpkgs.*` the modules set. A bare
          # package set is therefore not a shortcut around the module system, it
          # is the way to leave `nixpkgs.overlays` and `nixpkgs.config` working
          # inside this tree.
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = inputs;
          modules = homeSharedModules name host ++ [ (host.dir + "/home.nix") ];
        };
    in
    {
      nixosConfigurations = lib.mapAttrs (name: host: nixosFor name host) hosts;

      homeConfigurations = lib.mapAttrs' (
        name: host: lib.nameValuePair host.user (homeFor name host)
      ) hosts;
    };
}
