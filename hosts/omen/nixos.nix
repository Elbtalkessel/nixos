# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ./disko.nix

    ../../system/modules/core/audio.nix
    ../../system/modules/core/bluetooth.nix
    ../../system/modules/core/boot.nix
    ../../system/modules/core/dbus
    ../../system/modules/core/fonts.nix
    ../../system/modules/core/hardware
    ../../system/modules/core/locale.nix
    ../../system/modules/core/networking
    ../../system/modules/core/nix-settings.nix
    ../../system/modules/core/packages
    ../../system/modules/core/power.nix
    ../../system/modules/core/secrets.nix
    ../../system/modules/core/security.nix
    ../../system/modules/core/specialisation
    ../../system/modules/core/steam.nix
    ../../system/modules/core/storage
    ../../system/modules/core/system-services.nix
    ../../system/modules/core/users
    ../../system/modules/core/virtualisation
    ../../system/modules/core/web

    ../../system/modules/desktop/session
  ];

  networking.hostName = "omen";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
