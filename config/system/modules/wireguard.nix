_: {
  # Use systemd to manage interfaces: systemctl stop wg-quick-wg0
  # Protonvpn doesn't support v6
  # networking.enableIPv6 = false; doesn't work.
  boot.kernelParams = [ "ipv6.disable=1" ];
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [
        "10.2.0.2/32"
      ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = "/root/secrets/wg/wg0.key";
      peers = [
        {
          publicKey = "BTwnvm0OR6IzwefZlzTgJMn8NhISk8DtczUk7P74NH8=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "149.88.110.33:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
