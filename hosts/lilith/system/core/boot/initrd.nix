{
  # Configuration specific for the omen host.
  boot = {
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
  };
}
