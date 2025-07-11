{ lib, ... }:
{
  # https://wiki.nixos.org/wiki/NetworkManager
  networking = {
    nameservers = [
      # homelab dns server
      "192.168.1.90"
      # when out-of-home, quad9 dns
      "9.9.9.9"
      "149.112.112.112"
    ];
    networkmanager.dns = "none";
    # These options are unnecessary when managing DNS ourselves
    useDHCP = lib.mkDefault true;
    dhcpcd.enable = false;
  };
}
