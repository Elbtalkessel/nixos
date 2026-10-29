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
  services = lib.mkIf printing {
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    ipp-usb.enable = true;
    # Printer discovery won't work without it.
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
  users.users.${config.my.core.identity.username}.extraGroups = lib.mkIf printing [
    "scanner"
    "lp"
  ];
  hardware.sane = lib.mkIf printing {
    enable = true;
    # Probably a driver also required,
    # https://wiki.nixos.org/wiki/Scanners
  };
}
