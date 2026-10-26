{ config, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.my.core.identity.username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/${config.my.core.identity.username}/password".path;
    description = "${config.my.core.identity.username}";
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "tss"
    ];
    useDefaultShell = true;
  };
}
