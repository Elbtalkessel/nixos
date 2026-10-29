{ config, lib, ... }:
let
  inherit (config.my.apps) nsrv;
in
{
  # It doesn't have a declared configuration, just a docker container, but
  # for convenience proxied through Caddy.
  services.caddy.virtualHosts = lib.mkIf (nsrv.enable && nsrv.domain != null) {
    "${nsrv.domain}" = {
      hostName = "http://${nsrv.domain}";
      logFormat = "output file /var/log/caddy/access-${nsrv.domain}.log";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${nsrv.ip}:${toString nsrv.port}
      '';
    };
  };
}
