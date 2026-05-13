{ pkgs, ... }:
{
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

    # On kernel version 6.6.59 there was a bug with io_uring, zen is build from the latest stable kernel
    # (I assume even on ustable branch of nixos?), it fixed my issue, so I left it, no other reason.
    # https://lore.kernel.org/io-uring/f4bfc61b-9fe6-466a-a943-7143ed1ec804@kernel.dk/T/
    # https://nixos.wiki/wiki/Linux_kernel
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "uas"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [
      "hp-wmi"
    ];
  };
}
