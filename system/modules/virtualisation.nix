{ pkgs, config, ... }:
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

    # QEMU
    libvirtd = {
      enable = true;
      onShutdown = "shutdown";
      onBoot = "ignore";
      qemu = {
        swtpm.enable = true;
        runAsRoot = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
  };

  programs.virt-manager.enable = true;
  users.users.${config.my.username}.extraGroups = [
    "libvirtd"
    "docker"
  ];
}
