{
  config,
  lib,
  ...
}:
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
        profiles = {
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

  # Instead of symlinking, nixos will copy the hosts file, so you can modify it
  # in /etc/hosts, however changes will be dropped after applying a new configuration.
  environment.etc.hosts.mode = "0644";
}
