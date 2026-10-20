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
      url = "git+https://gitea.x.home.arpa/nix/nixvim.git?ref=main";
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
      url = "git+https://gitea.x.home.arpa/nix/nixpkgs.git?ref=master";
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
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codebase-memory-mcp.url = "github:DeusData/codebase-memory-mcp";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      # System string; widen to an attrset if any host leaves x86_64-linux.
      system = "x86_64-linux";

      # Module applied to both trees so `nixpkgs.overlays` and
      # `nixpkgs.config` survive a pre-built `pkgs` argument.
      nixpkgsModule = ./modules/common/nixpkgs.nix;

      # Per-host descriptor: `user` is the `homeConfigurations.<key>` and
      # the `users.users.<name>` account, `sops` enables secrets, `microvm`
      # makes this host a microvm guest, `microvmHost` makes it a microvm
      # host running the named guests.
      hosts = {
        omen = {
          user = "risus";
          sops = true;
          microvmHost = [ "atlas" ];
        };

        atlas = {
          user = "atlas";
          sops = true;
          microvm = true;
        };
      };

      /**
        sops config keyed by host name; shared by both NixOS and HM trees.

        # Type

        ```
        getSopsConfig :: String -> Attrs
        ```

        # Arguments

        name
        : Host name; resolves to ./hosts/${name}/secrets.yaml.

        # Example

        ```
        getSopsConfig "atlas"
        => {
             defaultSopsFile = ./hosts/atlas/secrets.yaml;
             defaultSopsFormat = "yaml";
             age.keyFile = "/etc/sops-nix/key.txt";
             environment.SOPS_AGE_KEY_FILE = "/etc/sops-nix/key.txt";
           }
        ```
      */
      getSopsConfig =
        name:
        let
          keyFile = "/etc/sops-nix/key.txt";
        in
        {
          defaultSopsFile = ./hosts/${name}/secrets.yaml;
          defaultSopsFormat = "yaml";
          age.keyFile = keyFile;
          environment.SOPS_AGE_KEY_FILE = keyFile;
        };

      /**
        NixOS system for a host. MicroVM guests additionally get the
        home-manager NixOS module (via modules/common/microvm/guest.nix) so
        a single `microvm -u` rebuild activates both trees at boot; microvm
        hosts get the guest runner and key provisioning (host.nix).

        # Type

        ```
        nixosFor :: String -> Attrs -> NixOS
        ```

        # Arguments

        name
        : Host name; resolves hosts/<name>/nixos.nix.

        host
        : Host descriptor; reads `user`, `sops`, optional `microvm` and
          optional `microvmHost`.

        # Example

        ```
        nixosFor "atlas" hosts.atlas
        => <nixos-system-atlas derivation>
        ```
      */
      nixosFor =
        name: host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            inherit (inputs) self;
            # Consumed by modules/common/microvm/{default,guest,host}.nix.
            hostName = name;
            hostDescriptor = host;
            # Passed through to home-manager's users so host home.nix can
            # reference flake inputs.
            homeSpecialArgs = inputs;
            sopsConfig = getSopsConfig name;
          };
          modules = [
            nixpkgsModule
            ./options
            ./modules/common/microvm
            { my.username = host.user; }
          ]
          ++ (lib.optional host.sops (
            { config, ... }:
            {
              imports = [ inputs.sops-nix.nixosModules.sops ];
              sops = getSopsConfig name;
              systemd.tmpfiles.rules = [
                "z /etc/sops-nix/key.txt 0640 root sops - - -"
              ];
              users.groups.sops = { };
              users.users.${config.my.username}.extraGroups = [ "sops" ];
            }
          ))
          ++ [ ./hosts/${name}/nixos.nix ];
        };

      /**
        Standalone home-manager configuration for a host; built outside
        NixOS for hosts that activate HM imperatively (`home-manager
        switch`).

        # Type

        ```
        homeFor :: String -> Attrs -> HomeConfiguration
        ```

        # Arguments

        name
        : Host name; passed to sops.

        host
        : Host descriptor; `host.user` is the `homeConfigurations.<key>`
          and `users.users.<name>` account.

        # Example

        ```
        homeFor "atlas" hosts.atlas
        => <home-manager-atlas derivation>
        ```
      */
      homeFor =
        name: host:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = inputs;
          modules = [
            nixpkgsModule
            ./options
            { my.username = host.user; }
          ]
          ++ (lib.optional host.sops {
            imports = [ inputs.sops-nix.homeManagerModules.sops ];
            sops = getSopsConfig name;
            home.sessionVariables.SOPS_AGE_KEY_FILE = "/etc/sops-nix/key.txt";
          })
          ++ [ ./hosts/${name}/home.nix ];
        };
    in
    {
      nixosConfigurations = lib.mapAttrs (name: host: nixosFor name host) hosts;

      homeConfigurations = lib.mapAttrs' (
        name: host: lib.nameValuePair host.user (homeFor name host)
      ) hosts;
    };
}
