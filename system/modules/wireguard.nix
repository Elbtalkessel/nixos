{ config, pkgs, ... }:
{
  # Protonvpn doesn't support v6
  # TODO: Add dns
  networking.enableIPv6 = false;
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [
        "10.2.0.2/32"
      ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = "/root/secrets/wg/wg0.key";
      peers = [
        {
          publicKey = "eqjhoqO6K1nLiej026+RkpSTHloVrOHLlMQaB0Tl5GM=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "156.146.50.5:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
