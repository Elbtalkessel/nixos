# Core system services: storage access, login sessions, keyring, firmware
# updates and the GVFS volume mounting that Nautilus depends on.
{
  services = {
    udisks2.enable = true;
    logind.settings.Login = {
      # Change runtime directory size
      # UPD: for what?
      RuntimeDirectorySize = "8G";
    };
    gnome.gnome-keyring.enable = true;
    # Daemon for updating some devices' firmware
    # https://github.com/fwupd/fwupd
    fwupd.enable = true;
  };
}
