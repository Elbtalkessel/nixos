{ config, lib, ... }:
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
  };

}
