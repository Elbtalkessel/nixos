{ pkgs, ... }:
{
  imports = [ <home-manager/nixos> ];
 
  # DOCKER / PODMAN
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

  # QEMU
  virtualisation.libvirtd = {
    enable = true;
  };
  programs.virt-manager = {
    enable = true;
  };

  # virt-manager requires dconf to remember settings
  programs.dconf = {
    enable = true;
  };
  home-manager.users.risus.dconf = {
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
  users.users.risus.extraGroups = [ "libvirtd" ];
}
