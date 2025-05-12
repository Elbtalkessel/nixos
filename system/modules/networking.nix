{
  config,
  lib,
  ...
}:
{
  boot.kernel.sysctl = {
    # Allow starting server @ :80
    "net.ipv4.ip_unprivileged_port_start" = 80;
  };
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wireless.env".path ];
        profiles =
          let
            defaultWifi =
              { ssid, password }:
              {
                connection.id = ssid;
                connection.type = "wifi";
                wifi.ssid = ssid;
                wifi-security = {
                  auth-alg = "open";
                  key-mgmt = "wpa-psk";
                  psk = password;
                };
              };
          in
          {
            home = defaultWifi {
              ssid = "$HOME_WIFI_SSID";
              password = "$HOME_WIFI_PASSWORD";
            };
            phobos = defaultWifi {
              ssid = "$PHOBOS_WIFI_SSID";
              password = "$PHOBOS_WIFI_PASSWORD";
            };
          };
      };
    };

    hostName = "omen";
    extraHosts = ''
      192.168.1.90 moon
    '';

    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = true;

    # Open ports in the firewall.
    # Allow HTTP and HTTPS traffic, required for guest vm to access host,
    # ideally to narrow down to specific IP.
    firewall.allowedTCPPorts = [
      80
      443
      8000
      9567
    ];

    # region Wireguard
    wg-quick.interfaces = {
      wg0 = lib.mkIf false {
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

  };

  # Instead of symlinking, nixos will copy the hosts file, so you can modify it
  # in /etc/hosts, however changes will be dropped after applying a new configuration.
  environment.etc.hosts.mode = "0644";
}
