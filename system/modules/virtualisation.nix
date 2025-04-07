{
  pkgs,
  config,
  ...
}:
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
        runAsRoot = false;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
  };

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };

  programs.virt-manager.enable = true;

  # USERS
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # TODO(conf): a central point to define default username.
  users.users.risus.extraGroups = [ "libvirtd" ];
}
