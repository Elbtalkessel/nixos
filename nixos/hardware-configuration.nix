# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4C3E-5620";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/root" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  fileSystems."/srv" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@srv" ];
    };

  fileSystems."/var/cache" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@cache" ];
    };

  fileSystems."/var/tmp" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@tmp" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@log" ];
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@docker" ];
    };

  fileSystems."/var/lib/libvirt" =
    { device = "/dev/disk/by-uuid/a102c1d7-ac6d-4b03-8427-06c40f10c05f";
      fsType = "btrfs";
      options = [ "subvol=@libvirt" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/a91d7899-2b41-4ee0-9167-fa9587f229a0"; }
    ];

  boot.initrd.luks.devices = {
    root = {
        device = "/dev/disk/by-uuid/7612ea92-6510-4a39-8757-954598872bbc";
        preLVM = true;
        allowDiscards = true;
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
