{
  hostName,
  ...
}:
{
  networking = {
    inherit hostName;

    # Ethernet now, a Wi-Fi dongle later — both land here. The machine has no
    # card of its own yet, so there is nothing Wi-Fi-specific to configure
    # until the dongle is installed.
    networkmanager.enable = true;

    # Kodi's web server (Chorus2) — the headless management UI on :8080.
    firewall.allowedTCPPorts = [
      8080
      3389
    ];
  };
}
