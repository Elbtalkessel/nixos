{ lib, ... }:
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

    # Broken for me, blank screen after loading graphic drivers.
    # kernelPackages = pkgs.linuxKernel.packages.linux_zen;

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

    kernelParams = lib.mkDefault [
      "quiet" # reduce kernel log verbosity during boot
      "splash" # enable graphical boot splash Plymouth
      "udev.log_priority=3" # only show udev errors (hide info/debug spam)
      "rd.systemd.show_status=auto" # systemd boot status only when needed (not verbose)
      "boot.shell_on_fail" # drop to shell if boot fails (debug safety net)
      "i8042.nopnp" # disable PS/2 PNP probing (removes i8042 AUX spam)
      "ima=off" # disable IMA subsystem (removes integrity measurement logs)
    ];

    plymouth.enable = true;

    kernelModules = lib.mkDefault [
      "hp-wmi"
    ];
  };
}
