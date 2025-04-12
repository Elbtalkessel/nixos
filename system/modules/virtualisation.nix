{ pkgs, ... }:
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
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        swtpm.enable = true;
        runAsRoot = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
  };

  programs.virt-manager.enable = true;
  users.users.risus.extraGroups = [ "libvirtd" ];
}
