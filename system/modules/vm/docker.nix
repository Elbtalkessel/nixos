{ config, ... }:
{
  # VIRTUALISATION
  # DOCKER / PODMAN
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  users.users.${config.my.username}.extraGroups = [ "docker" ];
}
