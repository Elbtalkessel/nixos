{
  pkgs,
  config,
  lib,
  ...
}:
let
  # Add support for printing / scanning.
  printing = true;
in
{
  services = {
    printing = {
      enable = printing;
      drivers = with pkgs; [
        # samsung printer support
        splix
        cups-filters
        cups-browsed
      ];
    };
    ipp-usb.enable = true;
  };
  users.users.${config.my.username}.extraGroups = lib.mkIf printing [
    "scanner"
    "lp"
  ];
  hardware.sane = {
    enable = printing;
    # Probably a driver also required,
    # https://wiki.nixos.org/wiki/Scanners
  };
}
