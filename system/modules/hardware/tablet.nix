_: {
  # Wacom graphical tablet support.
  # https://wiki.nixos.org/wiki/OpenTabletDriver
  hardware = {
    # Driver, daemon and GUI (the same name.)
    # https://opentabletdriver.net/Wiki/Install/Linux#nixos
    opentabletdriver.enable = true;
    uinput.enable = true;
  };
  boot.kernelModules = [ "uinput" ];
}
