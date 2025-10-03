# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  config,
  modulesPath,
  nixos-hardware,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # Mostly from https://github.com/NixOS/nixos-hardware/blob/master/omen/16-n0280nd/default.nix
    # The rest (kernel modules and prime config is in the omen.nix)
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd

    ./disko/omen.nix

    ./modules/bluetooth.nix
    ./modules/fonts.nix
    ./modules/i18n.nix
    ./modules/llm.nix
    ./modules/networking/networking.nix
    ./modules/nfs.nix
    ./modules/nvidia.nix
    ./modules/packages.nix
    # ./modules/passthrough.nix
    ./modules/samba.nix
    ./modules/services.nix
    ./modules/session.nix
    ./modules/sops.nix
    ./modules/steam.nix
    ./modules/virtualisation.nix
    #./modules/webdav.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    kernel.sysctl = {
      # Inotify is a kernel module that monitors file system events such as file creation,
      # deletion and modification. It allows other application to observe these changes.
      # Double amount of the default value.
      "fs.inotify.max_user_watches" = "1048576";
      # I have on average 400 processes running, double it and add a bit more just in case.
      "fs.inotify.max_user_instances" = "1024";
    };

    # https://lore.kernel.org/io-uring/f4bfc61b-9fe6-466a-a943-7143ed1ec804@kernel.dk/T/
    # Latest kernel 6.6.59 has an issue with the io_uring
    # Two options, or use kernel 6.11.6 or zen kernel which is 6.11.5
    # It seems switching to the zen kernel is the best solution as it forked from the stable kernel version
    # Another option is to pin a specific kernel version:
    # https://nixos.wiki/wiki/Linux_kernel
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "uas"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "hp-wmi"
    ];
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      # devenv requirement, allows devenv to manager caches.
      trusted-users = [ config.username ];
    };
  };

  # USERS
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/${config.username}/password".path;
    description = "${config.username}";
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "tss"
    ];
    # TODO(conf): need to sync this, home/modules/shell.nix and options.nix
    shell = pkgs.nushell;
  };

  # SECURITY
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics = {
      enable = true;
    };
    logitech.wireless.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
