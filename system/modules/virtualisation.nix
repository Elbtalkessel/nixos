{ pkgs, ... }: {

  # VIRTUALISATION
  # DOCKER / PODMAN
  virtualisation.podman = {
    enable = false;
    dockerCompat = true;
    dockerSocket = {
      enable = true;
    };
  };
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };


  # QEMU
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;
  # USERS
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.risus.extraGroups = [ "libvirtd" ];

}
