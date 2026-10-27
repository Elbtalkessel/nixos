{
  config,
  pkgs,
  lib,
  ...
}:
let
  sshMount = "/var/lib/ssh";
  homeMount = "/home/${config.my.core.identity.username}";
  inherit (config.my.core.microvm) atlas;
in
{
  microvm = {
    hypervisor = "qemu";
    vcpu = 4;
    mem = 8192;

    interfaces = lib.mkIf (atlas.itype != null) [
      (
        {
          type = atlas.itype;
          id = "atlas-tap";
          inherit (atlas) mac;
        }
        // lib.optionalAttrs (atlas.itype == "bridge") { bridge = "virbr0"; }
      )
    ];

    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
      # The age key for sops-nix is kept on the host outside the Nix store
      # and shared into the guest at /etc/sops-nix/key.txt. The file is
      # readable by the `wheel` group; atlas is a member, so the sops-nix
      # user service can use it. The existing tmpfiles rule inside the guest
      # tightens ownership to `root:sops` once the share is mounted.
      {
        source = "/var/lib/microvm/atlas/sops-nix";
        mountPoint = "/etc/sops-nix";
        tag = "atlas-sops-key";
        proto = "virtiofs";
      }
    ];

    # VSOCK gives the host a direct channel into the guest without needing
    # network connectivity.  `microvm -s atlas` rides this for SSH.  CIDs
    # 0/1/2 are reserved by the spec; 3 is the conventional starting point.
    vsock.cid = 4;

    # Writable overlay for /nix/store. Required for nix-daemon to run inside
    # the guest, which in turn is required by Home Manager activation. The
    # overlay only stores upperdir changes (profiles, GC roots); store paths
    # still come from the host's read-only /nix/store share.
    #
    # Never run `nix-collect-garbage` inside the guest. The guest's Nix
    # database lives on the ephemeral tmpfs root while this overlay is
    # persistent, so GC can delete a path that also exists in the host's
    # read-only layer; overlayfs records that as a whiteout, and the whiteout
    # then *hides* the host's copy on every later boot. A store path added by
    # a later rebuild then silently fails to appear, which surfaces far away
    # as `systemctl` reporting a unit as `bad` / "not found". Repair with
    # `nix-store --verify --check-contents --repair`, or delete the image on
    # the host to drop every accumulated whiteout at once.
    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        image = "nix-store-overlay.img";
        mountPoint = config.microvm.writableStoreOverlay;
        # MiB, read only when the image is first created. To resize: delete
        # the image on the host and restart the guest -- the volume comes
        # back empty at the new size.
        size = 15 * 1024;
      }
      # Persistent work data. The guest root filesystem is a tmpfs, so
      # everything outside /nix and this volume is ephemeral; this disk
      # image on the host survives guest restarts.
      {
        image = "atlas-home.img";
        mountPoint = homeMount;
        size = 20 * 1024;
      }
      # Persistent SSH host keys. Without this the tmpfs root would make
      # sshd-keygen mint fresh keys on every boot, breaking host key
      # verification across restarts. NixOS only generates a key when its
      # file is missing, so the first boot seeds the volume and later boots
      # reuse it until the key is deleted.
      {
        image = "ssh-host-keys.img";
        mountPoint = sshMount;
        size = 16;
      }
    ];
  };

  # A freshly formatted volume is root:root; hand it to the user so
  # projects can be written without root. The `d` rule re-applies on
  # every boot and is harmless when ownership already matches.
  systemd.tmpfiles.rules = [
    "d ${homeMount} 0750 ${config.my.core.identity.username} users - -"
  ];

  # Mount the key volume in stage-2, before activation and sshd-keygen run,
  # so the "generate if missing" check sees the persistent filesystem
  # instead of the tmpfs mountpoint.
  fileSystems."${sshMount}".neededForBoot = true;

  # Git access key for the atlas user: generated on first boot, persisted on
  # the same volume as the host keys, and never regenerated unless deleted.
  # Register the .pub on the gitea account that should own the pushes.
  systemd.services.atlas-git-key = {
    description = "Generate atlas git SSH key if missing";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      key=${sshMount}/atlas_git_ed25519
      if [ ! -s "$key" ]; then
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -C "atlas@gitea" -f "$key"
      fi
      chown ${config.my.core.identity.username}:users "$key" "$key.pub"
      chmod 600 "$key"
      chmod 644 "$key.pub"
    '';
  };
}
