# atlas -- a headless microvm that runs opencode with the oh-my-openagent plugin.
{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./config.nix

    ../../modules/system/core

    ./system/boot
  ];

  networking.hostName = "atlas";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # A new host, so start at the release the system is actually built from.
  system.stateVersion = "26.11";

  # MicroVM configuration
  microvm = {
    hypervisor = "qemu";
    vcpu = 4;
    mem = 8192;

    interfaces = [
      # To disable networking change the type to `tap` and remove `bridge`.
      {
        # Attach to the host's libvirt default bridge. The bridge runs a
        # dnsmasq DHCP server and NATs traffic through the host's uplink
        # (WiFi), giving the VM outbound access to the internet and the local
        # network without requiring WiFi MAC bridging.
        type = "bridge";
        id = "atlas-tap";
        bridge = "virbr0";
        mac = "02:00:00:00:00:01";
      }
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
    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        image = "nix-store-overlay.img";
        mountPoint = config.microvm.writableStoreOverlay;
        size = 2048;
      }
      # Persistent work data. The guest root filesystem is a tmpfs, so
      # everything outside /nix and this volume is ephemeral; this disk
      # image on the host survives guest restarts.
      {
        image = "atlas-projects.img";
        mountPoint = "/home/atlas/Projects";
        size = 20480;
      }
      # Persistent SSH host keys. Without this the tmpfs root would make
      # sshd-keygen mint fresh keys on every boot, breaking host key
      # verification across restarts. NixOS only generates a key when its
      # file is missing, so the first boot seeds the volume and later boots
      # reuse it until the key is deleted.
      {
        image = "ssh-host-keys.img";
        mountPoint = "/var/lib/ssh";
        size = 16;
      }
    ];
  };

  # Mount the key volume in stage-2, before activation and sshd-keygen run,
  # so the "generate if missing" check sees the persistent filesystem
  # instead of the tmpfs mountpoint.
  fileSystems."/var/lib/ssh".neededForBoot = true;

  # A freshly formatted volume is root:root; hand it to the user so
  # projects can be written without root. The `d` rule re-applies on
  # every boot and is harmless when ownership already matches.
  systemd.tmpfiles.rules = [
    "d /home/atlas/Projects 0750 atlas users - -"
  ];

  # The documented install flow configures machine access over SSH.
  # Admin access lands on root; `atlas` is an unprivileged runtime user
  # with no SSH login and no sudo. Drop in as root, then `su - atlas`.
  # Defaults for host key types, relocated onto the persistent volume --
  # /etc/ssh is tmpfs here.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.zsh.enable = true;

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
      key=/var/lib/ssh/atlas_git_ed25519
      if [ ! -s "$key" ]; then
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -C "atlas@gitea" -f "$key"
      fi
      chown atlas:users "$key" "$key.pub"
      chmod 600 "$key"
      chmod 644 "$key.pub"
    '';
  };

  users = {
    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7ulI5D34Y49wPgraM2iHLJHYzKBlJaB1akgibNJR1y risus@omen"
    ];

    defaultUserShell = pkgs.zsh;

    users.${config.my.username} = {
      isNormalUser = true;
      description = "atlas opencode host";
      hashedPasswordFile = config.sops.secrets."users/${config.my.username}/password".path;
      # No wheel: system changes only via a host-side rebuild. The flake's
      # sops module adds the `sops` group (age key access for HM secrets).
      extraGroups = [ ];
      useDefaultShell = true;
      # Headless service VM: logind must manage the user manager (and create
      # /run/user/1000) at boot. sops-nix mounts its secrets tmpfs there;
      # without a login session the runtime dir never appears and every
      # secret-dependent unit fails.
      linger = true;
    };
  };
}
