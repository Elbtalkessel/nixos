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
      trustedInterfaces =
        (lib.lists.optionals config.virtualisation.libvirtd.enable [
          "virbr0"
          "virbr1"
          "virbr2"
          "virbr3"
          "virbr4"
        ])
        ++ (lib.lists.optionals config.my.core.tailscale [
          # Always allow traffic from your Tailscale network
          config.services.tailscale.interfaceName
        ]);
      allowedTCPPorts = [
        # xrMPE server
        5555
        # AI server (see code/devops)
        9998
        # opencode
        4096
      ];
      allowedUDPPorts = lib.lists.optionals config.my.core.tailscale [
        config.services.tailscale.port
      ];
    };
  };
}
