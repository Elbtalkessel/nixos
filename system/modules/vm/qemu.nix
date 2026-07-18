{ pkgs, config, ... }:
{
  # VIRTUALISATION
  # DOCKER / PODMAN
  virtualisation = {
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
    spiceUSBRedirection.enable = true;
  };

  users.groups.libvirtd.members = [ config.my.username ];
  users.groups.kvm.members = [ config.my.username ];

  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [ phodav ];
}
