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
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wireless/env".path ];
        profiles = {
          home = wifi {
            ssid = "$HOME_WIFI_SSID";
            password = "$HOME_WIFI_PASSWORD";
          };
        };
      };
    };
  };
}
