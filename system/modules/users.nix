{ config, ... }:
{
  # USERS
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.my.username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/${config.my.username}/password".path;
    description = "${config.my.username}";
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
  users.users.steamos = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/steamos/password".path;
    description = "steamos";
    extraGroups = [
      "networkmanager"
      "input"
      "video"
      "audio"
    ];
    useDefaultShell = true;
  };
  users.defaultUserShell = config.my.shell.package;
  users.mutableUsers = false;
}
