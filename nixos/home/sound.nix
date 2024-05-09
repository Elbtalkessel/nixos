{ pkgs, ... }: {
  imports = [ <home-manager/nixos> ];

  # Bluetooth
  # doesn't work
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Add GUI for sound control
  users.users.risus.packages = with pkgs; [
    pavucontrol
  ];
}
