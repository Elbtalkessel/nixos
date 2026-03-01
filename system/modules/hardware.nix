{
  pkgs,
  config,
  lib,
  ...
}:
let
  # Add support for printing / scanning.
  printing = true;
  # Add support for game controllers.
  controller = true;
in
{
  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics.enable = true;
    logitech.wireless.enable = true;
    xpadneo.enable = controller;
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
