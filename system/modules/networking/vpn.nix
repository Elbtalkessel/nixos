{ config, ... }:
{
  # region Wireguard
  wg-quick.interfaces = {
    wg0 = {
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = config.sops.secrets."wireguard/wg0".path;
      peers = [
        {
          publicKey = "Eq21XF3A63IbiEDBdIj5T2uKXtHZDj7mfiJIXVcOQXk=";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "62.169.136.235:51820";
        }
      ];
    };
  };
  # endregion Wireguard
}
