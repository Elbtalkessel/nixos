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
    vcpu = 2;
    mem = 2049;

    interfaces = [
      {
        type = "tap";
        id = "atlas-tap";
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
    ];
  };

  # The documented install flow configures the machine over SSH.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.${config.my.username} = {
    isNormalUser = true;
    description = "atlas opencode host";
    hashedPasswordFile = config.sops.secrets."users/${config.my.username}/password".path;
    extraGroups = [
      "wheel"
    ];
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7ulI5D34Y49wPgraM2iHLJHYzKBlJaB1akgibNJR1y risus@omen"
    ];
  };
}
