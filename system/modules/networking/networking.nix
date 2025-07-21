{
  config,
  lib,
  ...
}:
let
  defaultWifi =
    {
      ssid,
      password,
      dns ? null,
    }:
    {
      connection.id = ssid;
      connection.type = "wifi";
      wifi.ssid = ssid;
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
        psk = password;
      };
      ipv4 = lib.mkIf (dns != null) {
        inherit dns;
        ignore-auto-dns = true;
        method = "auto";
      };
      # I just don't know / care how to configure it.
      ipv6 = lib.mkIf (dns != null) {
        method = "disabled";
      };
    };
in
{
  boot.kernel.sysctl = {
    # Allow starting unpriv services @ 80 and higher.
    "net.ipv4.ip_unprivileged_port_start" = 80;
  };
  networking = {
    useDHCP = lib.mkDefault true;
    # I'm unsure on this one.
    dhcpcd.enable = false;

    networkmanager = {
      enable = true;
      # dns = "none";
      ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wireless.env".path ];
        profiles = {
          home = defaultWifi {
            ssid = "$HOME_WIFI_SSID";
            password = "$HOME_WIFI_PASSWORD";
            # dnsmasq instance available exclusively on this network.
            dns = "192.168.1.90";
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
