{ pkgs, ... }: {
  # Logitech MX Master 3 configuration
  
  # driver
  environment.systemPackages = with pkgs; [
    logiops
  ];
  
  # configuration
  environment.etc = {
    "logid.cfg".source = ../etc/logid.cfg;
  };
  
  # service
  systemd.services.logid.wantedBy = [ "multi-user.target" ];
}
