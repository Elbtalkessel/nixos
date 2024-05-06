{ pkgs, ... }:
{
  imports = [ <home-manager/nixos> ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket = {
      enable = true;
    };
  };

  users.users.risus.packages = with pkgs; [
    lazydocker 
  ];

  home-manager.users.risus.home.shellAliases = {
    d = "DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker";
  };
}
