{ pkgs, ... }: {
  # Logitech MX Master 3 configuration
  
  # configuration
  environment.etc = {
    "logid.cfg".source = ../etc/logid.cfg;
  };
  
  # service
  systemd.packages = [ pkgs.logiops ];
  systemd.services.logid = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };
}
