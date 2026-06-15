{ lib, ... }:
let
  domain = "ai.omen.home.arpa";
  port = 9080;
  enable = false;
in
{
  services.open-webui = {
    inherit enable;
    inherit port;
  };
  services.caddy.virtualHosts = lib.mkIf enable {
    "http://${domain}".extraConfig = ''
      encode zstd gzip
      reverse_proxy :${toString port} {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
