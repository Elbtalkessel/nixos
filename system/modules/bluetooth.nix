{pkgs, ...}: {
  # HARDWARE
  # Bluetooth
  # doesn't work, nor bluetoothctl nor blueman. authentication cancelled...
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  environment.systemPackages = with pkgs; [
    bluetuith
  ];
}
