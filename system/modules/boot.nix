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
}
