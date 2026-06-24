{ config, ... }:
{
  services.openssh = {
    enable = true;
    # At the moment used only to connect from usb connected
    # android device to machine, done via binding 22 port to android's 2222
    # and doesn't require exposing 22 outside.
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ config.my.username ];
      MaxAuthTries = 3;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };
}
