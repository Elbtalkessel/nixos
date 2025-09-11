{
  config,
  lib,
  ...
}:
let
  mkWifi =
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
  imports = [
    ./tailscale.nix
  ];

  boot.kernel.sysctl = {
    # Allow starting unpriv services @ 80 and higher.
    "net.ipv4.ip_unprivileged_port_start" = 80;
  };
  networking = {
    useDHCP = lib.mkDefault true;
    # TODO: I'm unsure on this one.
    dhcpcd.enable = false;

    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wireless.env".path ];
        profiles = {
          home = mkWifi {
            ssid = "$HOME_WIFI_SSID";
            password = "$HOME_WIFI_PASSWORD";
            dns = "192.168.1.90;9.9.9.9";
          };
          phobos = mkWifi {
            ssid = "$PHOBOS_WIFI_SSID";
            password = "$PHOBOS_WIFI_PASSWORD";
          };
        };
      };
    };

    hostName = "omen";

    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall = {
      enable = true;
      # At some point virtual machines has stopped getting an IP address,
      # adding ports 67 and 68 to allowedUDPPorts fixed it. However, machines
      # didn't have internet connection. So, now everything from these 4 interfaces
      # (a random number, tbh, vagrant likes to create bridges), bypasses firewall.
      trustedInterfaces = lib.mkIf config.virtualisation.libvirtd.enable [
        "virbr0"
        "virbr1"
        "virbr2"
        "virbr3"
        "virbr4"
      ];
    };
  };

  # Instead of symlinking, nixos will copy the hosts file, so you can modify it
  # in /etc/hosts, however changes will be dropped after applying a new configuration.
  environment.etc.hosts.mode = "0644";

  security.pki.certificateFiles = [ ../../../assets/home-ca.pem ];
}
