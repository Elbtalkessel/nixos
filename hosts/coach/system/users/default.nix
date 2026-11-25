{ config, ... }:
{
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7ulI5D34Y49wPgraM2iHLJHYzKBlJaB1akgibNJR1y risus@omen"
      ];
    };

    # Operator: SSH admin, key-only, passwordless sudo (no password to type).
    ${config.my.core.identity.username} = {
      isNormalUser = true;
      description = "coach media box operator";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "input"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7ulI5D34Y49wPgraM2iHLJHYzKBlJaB1akgibNJR1y risus@omen"
      ];
    };

    # Kodi runs its own unprivileged session (greetd autologin). No shell, no
    # SSH, no sudo — a compromised Kodi addon cannot escalate.
    kodi = {
      isNormalUser = true;
      description = "Kodi appliance session";
      extraGroups = [
        "video"
        "audio"
        "input" # libinput for the G10S air-mouse
      ];
    };
  };
}
