{
  config,
  ...
}:
let
  wifi =
    {
      ssid,
      password,
      ipv4 ? null,
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
      ipv4 =
        if ipv4 == null then
          { method = "auto"; }
        else
          {
            method = "manual";
            address1 = "${ipv4.address},${ipv4.gateway}";
            inherit (ipv4) dns;
          };
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
            # Reserve 192.168.1.93 for lilith (nix/nixos#14).
            ipv4 = {
              address = "192.168.1.93/24";
              gateway = "192.168.1.1";
              dns = "192.168.1.130;";
            };
          };
        };
      };
    };
  };
}
