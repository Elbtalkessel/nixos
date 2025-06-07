{
  config,
  lib,
  pkgs,
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
  dnsCryptStateDirectory = "dnscrypt-proxy";
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

  # region Encrypted DNS and local network forwarding support
  # https://wiki.nixos.org/wiki/Encrypted_DNS
  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    dhcpcd.extraConfig = "nohook resolv.conf";
  };
  networking.networkmanager.dns = "none";
  services.dnscrypt-proxy2 = {
    enable = true;
    # See https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
    settings = {
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"; # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        cache_file = "/var/lib/${dnsCryptStateDirectory}/public-resolvers.md";
      };

      # Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
      ipv6_servers = true;
      block_ipv6 = false;

      require_dnssec = true;
      require_nolog = false;
      require_nofilter = true;

      # If you want, choose a specific set of servers that come from your sources.
      # Here it's from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # If you don't specify any, dnscrypt-proxy will automatically rank servers
      # that match your criteria and choose the best one.
      # server_names = [ ... ];

      forwarding_rules = builtins.toString (
        pkgs.writeText "forwarding-rules.txt" ''
          ## $DHCP to use the default DNS resolvers provided by the DHCP server

          ## In order to enable this feature, the "forwarding_rules" property needs to
          ## be set to this file name inside the main configuration file.

          ## Blocking IPv6 may prevent local devices from being discovered.
          ## If this happens, set `block_ipv6` to `false` in the main config file.

          ## Forward *.nas.ld to 192.168.1.90
          nas.ld 192.168.1.90

          ## Forward *.local to the resolvers provided by the DHCP server
          # local            $DHCP

          ## Forward *.internal to 192.168.1.1, and if it doesn't work, to the
          ## DNS from the local DHCP server, and if it still doesn't work, to the
          ## bootstrap resolvers
          # internal         192.168.1.1,$DHCP,$BOOTSTRAP

          ## Forward queries for example.com and *.example.com to 9.9.9.9 and 8.8.8.8
          # example.com      9.9.9.9,8.8.8.8

          ## Forward queries to a resolver using IPv6
          # ipv6.example.com [2001:DB8::42]

          ## Forward to a non-standard port number
          # x.example.com    192.168.0.1:1053
          # y.example.com    [2001:DB8::42]:1053

          ## Forward queries for .onion names to a local Tor client
          ## Tor must be configured with the following in the torrc file:
          ## DNSPort 9053
          ## AutomapHostsOnResolve 1

          # onion            127.0.0.1:9053
        ''
      );
    };
  };
  systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = dnsCryptStateDirectory;
  # endregion

  # Instead of symlinking, nixos will copy the hosts file, so you can modify it
  # in /etc/hosts, however changes will be dropped after applying a new configuration.
  environment.etc.hosts.mode = "0644";
}
