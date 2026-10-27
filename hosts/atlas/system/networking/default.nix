{ hostName, config, ... }:
{
  networking = {
    inherit hostName;
    firewall.allowedTCPPorts = [ config.my.apps.opencode.port ];
  };
}
