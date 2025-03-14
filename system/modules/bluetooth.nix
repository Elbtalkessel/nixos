{ pkgs, ... }:
{
  # HARDWARE
  # Bluetooth
  # doesn't work, nor bluetoothctl nor blueman. authentication cancelled...
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  environment.systemPackages = with pkgs; [
    bluetuith
  ];
}
