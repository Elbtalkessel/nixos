_: {
  services.dnsmasq = {
    enable = false;
    settings = {
      no-resolv = true;
      address = [
        "/home.arpa/192.168.121.98"
      ];
      server = [
        "9.9.9.9"
        "149.112.112.112"
      ];
    };
  };
}
