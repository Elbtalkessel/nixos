{
  # Local DNS overrides. The atlas MicroVM has a pinned DHCP lease (see
  # hosts/omen/system/core/networking/atlas-vm.nix), so its name is wired
  # declaratively via services.dnsmasq.settings.address. Ad-hoc records
  # can still be dropped into /var/lib/dnsmasq/dnsmasq.conf.
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
      no-resolv = true;
      strict-order = true;
      server = [
        "192.168.1.130"
        "9.9.9.9"
        "149.112.112.112"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/dnsmasq 0750 root root -"
    "f /var/lib/dnsmasq/dnsmasq.conf 0644 root root -"
  ];

  systemd.services.dnsmasq = {
    after = [ "systemd-tmpfiles-setup.service" ];
    wants = [ "systemd-tmpfiles-setup.service" ];
  };
}
