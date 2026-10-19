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

    ../../modules/system/core/locale
    ../../modules/system/core/nix-settings/settings.nix
    ../../modules/system/core/networking/certificates.nix
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
    ];

    # VSOCK gives the host a direct channel into the guest without needing
    # network connectivity.  `microvm -s atlas` rides this for SSH.  CIDs
    # 0/1/2 are reserved by the spec; 3 is the conventional starting point.
    vsock.cid = 4;
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
