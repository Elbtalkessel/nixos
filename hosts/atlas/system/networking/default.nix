{ hostName, ... }:
{
  networking = {
    inherit hostName;
    firewall.allowedTCPPorts = [ 80 ];
  };
}
