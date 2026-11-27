# MicroVM guest: the hypervisor module plus Home Manager integration.
#
# A guest's system tree owns its user tree so a single rebuild -- whether
# `nixos-rebuild switch` or `microvm -u` -- activates both at boot. Home
# Manager is therefore wired as a NixOS module here rather than as the
# standalone `homeFor` build.
{
  config,
  lib,
  pkgs,
  self,
  hostName,
  hostDescriptor,
  homeSpecialArgs,
  sopsConfig,
  microvm,
  home-manager,
  sops-nix,
  ...
}:
{
  imports = [
    microvm.nixosModules.microvm
    home-manager.nixosModules.home-manager
  ];

  # Shadow `nix-collect-garbage` with a refusing wrapper (`hiPrio`, priority -10)
  # to win the `system-path` collision (ignoreCollisions, ascending priority).
  environment.systemPackages = [
    (lib.meta.hiPrio (
      pkgs.writeShellScriptBin "nix-collect-garbage" ''
        cat >&2 <<'EOF'
        nix-collect-garbage is disabled inside this microVM.

        The guest's /nix/store is an overlay: the host's store is the read-only
        lower layer and this guest's writes go to a persistent upper layer. The
        Nix database lives on the ephemeral tmpfs root and is rebuilt on every
        boot, so GC judges liveness from an almost empty database. Deleting a
        path that the host still provides does not remove it; overlayfs records
        a whiteout, and the whiteout keeps hiding the host's copy on every
        later boot.

        The symptom is not "GC failed". It is a store path that silently never
        appears again, surfacing much later as a systemd unit reported as `bad`
        / "not found" by `systemctl`.

        Run GC on the host instead, where store and database agree:

            sudo nix-collect-garbage -d          # on omen

        If this guest was already damaged by an earlier GC, repair it with:

            nix-store --verify --check-contents --repair

        or delete /var/lib/microvms/<name>/nix-store-overlay.img on the host and
        restart the VM to drop every accumulated whiteout at once.
        EOF
        exit 1
      ''
    ))
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = homeSpecialArgs;

    users.${config.my.core.identity.username} = {
      imports = [
        (self + "/options")
        { my.core.identity.username = hostDescriptor.user; }
      ]
      ++ (lib.optional hostDescriptor.sops {
        imports = [ sops-nix.homeManagerModules.sops ];
        sops = sopsConfig;
        home.sessionVariables.SOPS_AGE_KEY_FILE = "/etc/sops-nix/key.txt";
      })
      ++ [ (self + "/hosts/${hostName}/home.nix") ];
    };
  };
}
