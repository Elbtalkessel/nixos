{ config, ... }:
{
  security = {
    # PipeWire needs realtime scheduling for glitch-free HDMI audio.
    rtkit.enable = true;
    # Session-level auth for NetworkManager, logind and Steam.
    polkit.enable = true;

    # The operator reaches root over SSH with a key; there is no password on
    # the account, so sudo must not prompt for one.
    sudo.extraRules = [
      {
        users = [ config.my.core.identity.username ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
