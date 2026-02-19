_: {
  services.dnsmasq = {
    enable = true;
    settings = {
      listen-address = [
        "::1"
        "127.0.0.1"
      ];
      bind-interfaces = true;
      address = [
        "/pbn.home.arpa/192.168.121.191"
        "/home.arpa/192.168.121.98"
      ];
      server = [
        "9.9.9.9"
        "149.112.112.112"
      ];
    };
  };
}
