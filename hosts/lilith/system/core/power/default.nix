# Power management. The clients for these daemons are installed by Home
# Manager.
{
  services = {
    # for changing power profile.
    power-profiles-daemon.enable = true;
    # for displaying battery level.
    upower.enable = true;
  };
}
