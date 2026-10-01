{ config, ... }:
{
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
}
