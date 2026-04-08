_: {
  # To add local hosts, edit `/var/lib/dnsmasq/dnsmasq.conf` and
  # restart dnsmasq service. IP changes, no point to add it here.
  # This also means you need to add this file manually and set correct
  # ownership of dnsmasq:dnsmasq.
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    resolveLocalQueries = true;
    settings = {
      conf-file = "/var/lib/dnsmasq/dnsmasq.conf";
      listen-address = [
        "::1"
        "127.0.0.1"
      ];
      bind-interfaces = true;
      domain-needed = true;
      bogus-priv = true;
      expand-hosts = true;
      server = [
        "9.9.9.9"
        "149.112.112.112"
      ];
    };
  };
  networking.hosts = {
    # Make easy anti cheat work
    "0.0.0.0" = [ "modules-cdn.eac-prod.on.epicgames.com" ];
  };
}
