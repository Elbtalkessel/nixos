_: {
  # To add local hosts, edit /etc/dnsmasq-conf.conf,
  # IP changes, no point to add it here.
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    resolveLocalQueries = true;
    settings = {
      listen-address = [
        "::1"
        "127.0.0.1"
      ];
      bind-interfaces = true;
      domain-needed = true;
      bogus-priv = true;
      local = "/home.arpa/";
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
