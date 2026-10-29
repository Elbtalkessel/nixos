{ config, lib, ... }: {
  networking = {
    nftables.enable = true;
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall = {
      enable = true;
      # At some point virtual machines has stopped getting an IP address,
      # adding ports 67 and 68 to allowedUDPPorts fixed it. However, machines
      # didn't have internet connection. So, now everything from these 4 interfaces
      # (a random number, tbh, vagrant likes to create bridges), bypasses firewall.
      trustedInterfaces = lib.lists.optionals config.virtualisation.libvirtd.enable [
        "virbr0"
        "virbr1"
        "virbr2"
        "virbr3"
        "virbr4"
      ];
    };
  };
}
