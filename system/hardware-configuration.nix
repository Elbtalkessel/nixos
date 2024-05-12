# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "uas" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@nix" ];
    };

  fileSystems."/root" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@root" ];
    };

  fileSystems."/srv" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@srv" ];
    };

  fileSystems."/var/cache" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@cache" ];
    };

  fileSystems."/var/tmp" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@tmp" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@log" ];
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@docker" ];
    };

  fileSystems."/var/lib/libvirt" =
    { device = "/dev/disk/by-uuid/250192ad-0988-4002-8092-96a424823d9f";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async,subvol=@libvirt" ];
    };

  fileSystems."/home" =
    { device = "/dev/vg/home";
      fsType = "btrfs";
      options = [ "noatime,space_cache=v2,compress=lzo,discard=async" ];
    };

  fileSystems."/media" =
    { device = "/dev/disk/by-uuid/81b021ae-7599-4132-af20-47707df7187f";
      fsType = "xfs";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/7725-C16F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d0060720-29c2-4c26-9dee-5bdfdddbdb3b"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
