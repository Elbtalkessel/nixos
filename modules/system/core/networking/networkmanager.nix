{ config, ... }:
let
  wifi =
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
      ipv4.method = "auto";
    };
in
{
  networking = {
    useDHCP = false;
    networkmanager = {
      # Don't set `dns = "dnsmasq"` if services.dnsmasq.enable is true,
      # this runs networkmanager's dnsmasq instance.
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wireless.env".path ];
        profiles = {
          home = wifi {
            ssid = "$HOME_WIFI_SSID";
            password = "$HOME_WIFI_PASSWORD";
          };
          home_2 = wifi {
            ssid = "$HOME_2_WIFI_SSID";
            password = "$HOME_2_WIFI_PASSWORD";
          };
          phobos = wifi {
            ssid = "$PHOBOS_WIFI_SSID";
            password = "$PHOBOS_WIFI_PASSWORD";
          };
        };
      };
    };
  };
}
