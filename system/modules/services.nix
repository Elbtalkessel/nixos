_: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
    };
  };
  # List services that you want to enable:
  services = {
    udisks2.enable = true;
    # Change runtime directory size
    logind.extraConfig = "RuntimeDirectorySize=8G";
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    # Daemon for updating some devices' firmware
    # https://github.com/fwupd/fwupd
    fwupd.enable = true;
  };
}
