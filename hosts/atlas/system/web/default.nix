# atlas web reverse proxy -- serves the opencode web UI over plain HTTP.
#
# Atlas reaches the network only through omen's virbr0 bridge, and
# `oc.s3.home.arpa` resolves on the internal RFC 8375 home.arpa zone.
# There is no publicly reachable address and no ACME path to this guest,
# so Caddy auto-HTTPS is switched off globally and the vhost is served
# over HTTP on the standard port.
{ config, ... }:
let
  DOMAIN = "oc.s3.home.arpa";
in
{
  services.caddy = {
    enable = true;

    # No automatic HTTPS: the internal .home.arpa name cannot be issued a
    # public certificate and the guest has no route to complete ACME
    # challenges, so serve plain HTTP and disable the redirect/TLS machinery.
    globalConfig = "auto_https off";

    virtualHosts."${DOMAIN}" = {
      # The explicit `http://` scheme is load-bearing, not decoration.
      # Caddy derives the listener port from the site address scheme: a bare
      # hostname is an HTTPS site and binds :443, which would leave the
      # firewall's :80 hole unused. The `listen` directive that used to
      # override this was removed in Caddy 2.11, so the scheme is the only
      # way to select the port. With it, Caddy serves plain HTTP on :80 and
      # skips ACME for this site.
      hostName = "http://${DOMAIN}";

      # `hostName` now carries the scheme, so the module's default access-log
      # name would come out as "access-http:__oc.s3.home.arpa.log". Pin it
      # back to the plain host name.
      logFormat = "output file /var/log/caddy/access-${DOMAIN}.log";

      extraConfig = ''
        encode zstd gzip

        # Caddy preserves the inbound Host header on reverse_proxy by default,
        # which the opencode web UI relies on for its own host checks; the
        # upstream is the opencode web server from the home tree, which is
        # also reachable on loopback.
        reverse_proxy 127.0.0.1:${toString config.my.service.opencode.port}
      '';
    };
  };
}
