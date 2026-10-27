{ config, ... }:
{
  # VIRTUALISATION
  # DOCKER / PODMAN
  virtualisation = {
    podman = {
      enable = true;
    };
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  users.users.${config.my.core.identity.username}.extraGroups = [ "docker" ];
}
