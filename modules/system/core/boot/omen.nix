{ lib, ... }:
{
  # Configuration specific for the omen host.
  boot = {
    kernel.sysctl = {
      # Inotify is a kernel module that monitors file system events such as file creation,
      # deletion and modification. It allows other application to observe these changes.
      # Double amount of the default value.
      "fs.inotify.max_user_watches" = "1048576";
      # I have on average 400 processes running, double it and add a bit more just in case.
      "fs.inotify.max_user_instances" = "1024";
    };
    initrd = {
      # Modules available during early boot.
      # There are much more, during boot from an encrypted
      # device on nvme you only need nvme driver and driver for keyboard.
      # In case if encryption key will be moved to an external USB device,
      # You'd probably need xhci_pci, usb_storage, depending on device.
      availableKernelModules = [
        "nvme" # nvme driver.
        "usbhid" # Keyboard, mouse, etc.
      ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = lib.mkDefault [
      "hp-wmi"
    ];
  };
}
