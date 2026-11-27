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
      url = "github:Elbtalkessel/nixvim/main";
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
      url = "github:Elbtalkessel/nixpkgs/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gather = {
      url = "github:Elbtalkessel/gather/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nuenv = {
      # https://determinate.systems/blog/nuenv/
      url = "https://flakehub.com/f/xav-ie/nuenv/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
      # Takes no nixpkgs input, so there is nothing here to follow.
    };
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
    codebase-memory-mcp = {
      url = "github:DeusData/codebase-memory-mcp";
    };
    comfyui-nix = {
      url = "github:utensils/comfyui-nix";
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

      # System string; widen to an attrset if any host leaves x86_64-linux.
      system = "x86_64-linux";

      # Module applied to both trees so `nixpkgs.overlays` and
      # `nixpkgs.config` survive a pre-built `pkgs` argument.
      nixpkgsModule = ./hosts/_shared/nixpkgs.nix;

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
          user = "kimberlee";
          sops = true;
          microvm = true;
        };

        couch = {
          user = "risus";
          sops = false;
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
        home-manager NixOS module (via _shared/microvm/guest.nix) so
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
            # Consumed by _shared/microvm/{default,guest,host}.nix.
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
            ./hosts/_shared/microvm
            { my.core.identity.username = host.user; }
          ]
          ++ (lib.optional host.sops (
            { ... }:
            {
              imports = [ inputs.sops-nix.nixosModules.sops ];
              sops = getSopsConfig name;
              # root:users (gid 100) is stable across machines. Safe while each
              # host has only one machine user.
              systemd.tmpfiles.rules = [
                "z /etc/sops-nix/key.txt 0640 root users - - -"
              ];
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
        : Host descriptor; `host.user` is the `users.users.<name>` account.
          The resulting `homeConfigurations` key is `${host.user}-${name}`
          so each host has a unique entry even when users are shared.

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
            { my.core.identity.username = host.user; }
          ]
          ++ (lib.optional host.sops {
            imports = [ inputs.sops-nix.homeManagerModules.sops ];
            sops = getSopsConfig name;
            home.sessionVariables.SOPS_AGE_KEY_FILE = "/etc/sops-nix/key.txt";
          })
          ++ [ ./hosts/${name}/home.nix ];
        };

      # Generic headless installer ISO: boots with key-only SSH over DHCP so a
      # machine can be installed from another box on the LAN — no monitor next
      # to the ethernet port. Build and flash:
      #   nix build .#nixosConfigurations.nixbase.config.system.build.isoImage
      nixbaseInstaller = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ./options
          ./hosts/_shared/config.nix
          { config.my.core.identity.username = "nixos"; }

          ./hosts/_shared/system/core
          (
            { config, ... }:
            {
              networking.hostName = "nixbase";
              users.users.root.openssh.authorizedKeys.keys = [ config.my.core.pubkey ];
              services.openssh = {
                enable = true;
                settings = {
                  PermitRootLogin = "prohibit-password";
                  PasswordAuthentication = false;
                  KbdInteractiveAuthentication = false;
                };
              };
            }
          )
        ];
      };
    in
    {
      nixosConfigurations = (lib.mapAttrs (name: host: nixosFor name host) hosts) // {
        nixbase = nixbaseInstaller;
      };

      homeConfigurations = lib.mapAttrs' (
        name: host: lib.nameValuePair "${host.user}@${name}" (homeFor name host)
      ) hosts;
    };
}
