{ config, ... }: {

  users = {
    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7ulI5D34Y49wPgraM2iHLJHYzKBlJaB1akgibNJR1y risus@omen"
    ];

    defaultUserShell = config.my.core.shell.package;

    users.${config.my.core.identity.username} = {
      isNormalUser = true;
      description = "atlas opencode host";
      hashedPasswordFile = config.sops.secrets."users/${config.my.core.identity.username}/password".path;
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
