{
  pkgs,
  config,
  lib,
  ...
}:
let
  # Add support for printing / scanning.
  # At least for xbox one controller, latest kernel supports it
  # without any additional drivers, (i.e. xone, xpadneo.)
  printing = true;
in
{
  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics.enable = true;
    logitech.wireless.enable = true;
    sane = {
      enable = printing;
      # Probably a driver also required,
      # https://wiki.nixos.org/wiki/Scanners
    };
  };
  services.printing = {
    enable = printing;
    drivers = [
      # samsung printer support
      pkgs.splix
    ];
  };
  users.users.${config.my.username}.extraGroups = lib.mkIf printing [
    "scanner"
    "lp"
  ];
}
