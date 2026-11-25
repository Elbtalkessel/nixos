{ config, ... }:
{
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [ config.my.core.pubkey ];
    };

    # Operator: SSH admin, key-only, passwordless sudo (no password to type).
    ${config.my.core.identity.username} = {
      isNormalUser = true;
      description = "couch media box operator";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "input"
      ];
      openssh.authorizedKeys.keys = [ config.my.core.pubkey ];
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
