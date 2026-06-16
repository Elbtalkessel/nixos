{ pkgs, ... }:
{
  nix = {
    # rewrite it using suggestions from
    # https://www.reddit.com/r/NixOS/comments/16tpwb3/how_to_only_keep_the_last_5_generations/
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 7d";
    # };
    optimise = {
      automatic = true;
    };
  };
  # List services that you want to enable:
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
    flatpak.enable = true;
    # hyprpanel "soft" requirements (installed by home-manager).
    # for changing power profile.
    power-profiles-daemon.enable = true;
    # for displying battery level.
    upower.enable = true;
    # ---
    # "soft" nautilus dependency
    gvfs.enable = true;
    # https://github.com/NixOS/nixpkgs/issues/303078#issuecomment-4698342707
    dbus = {
      brokerPackage = pkgs.dbus-broker.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./patches/dbus-broker-logging.patch
        ];
      });
    };
  };
}
