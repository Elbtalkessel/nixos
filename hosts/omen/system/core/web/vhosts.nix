{ lib, config, ... }:
{
  # Transforms "servable" options into Caddy vhost defs.
  # "servable" type definition is in options/srv.nix, example:
  # { ip = "127.0.0.1"; port = 8080; proxy = true; subdomain = "foo" }
  services.caddy.virtualHosts =
    lib.attrsToList config.my.srv
    |> lib.filter (i: i.name != "domain")
    |> lib.filter (i: i.value.proxy && i.value.ip != null && i.value.port != null)
    |> lib.map (
      attr:
      let
        domain = "${attr.value.subdomain}.${config.my.srv.domain}";
      in
      {
        name = domain;
        value = {
          hostName = "http://${domain}";
          logFormat = "output file /var/log/caddy/access-${domain}.log";
          extraConfig = ''
            encode zstd gzip
            reverse_proxy ${attr.value.ip}:${toString attr.value.port}
          '';
        };
      }
    )
    |> lib.listToAttrs;
}
