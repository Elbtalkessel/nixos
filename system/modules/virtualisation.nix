{ pkgs, config, ... }: {

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
    onShutdown = "suspend";
    onBoot = "ignore";
    qemu = {
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
      swtpm.enable = true;
      runAsRoot = false;
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
  users.users.risus.extraGroups = [ "libvirtd" ];

}
