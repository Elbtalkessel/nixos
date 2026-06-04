{ config, lib, ... }:
let
  _ = builtins;
  ls = root: (_.map (f: root + "/${f}") (_.attrNames (_.readDir root)));
in
{
  boot.kernel.sysctl = {
    # Allow starting unpriv services @ 80 and higher.
    "net.ipv4.ip_unprivileged_port_start" = 80;
  };
  networking = {
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall = {
      enable = true;
      # At some point virtual machines has stopped getting an IP address,
      # adding ports 67 and 68 to allowedUDPPorts fixed it. However, machines
      # didn't have internet connection. So, now everything from these 4 interfaces
      # (a random number, tbh, vagrant likes to create bridges), bypasses firewall.
      trustedInterfaces = lib.mkIf config.virtualisation.libvirtd.enable [
        "virbr0"
        "virbr1"
        "virbr2"
        "virbr3"
        "virbr4"
      ];
      allowedTCPPorts = [
        # xrMPE server
        5555
        # AI server (see code/devops)
        9998
      ];
    };
  };
  security.pki.certificateFiles = ls ../../../assets/certificates;
}
