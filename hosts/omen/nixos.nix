# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  modulesPath,
  lib,
  disko,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    disko.nixosModules.disko
    ./disko.nix
    ./filesystem.nix
    ./config.nix

    ../../modules/system/core/audio
    ../../modules/system/core/bluetooth
    ../../modules/system/core/boot
    ../../modules/system/core/dbus
    ../../modules/system/core/fonts
    ../../modules/system/core/hardware
    ../../modules/system/core/locale
    ../../modules/system/core/networking
    ../../modules/system/core/nix-settings
    ../../modules/system/core/packages
    ../../modules/system/core/power
    ../../modules/system/core/security
    ../../modules/system/core/specialisation
    ../../modules/system/core/storage
    ../../modules/system/core/system-services
    ../../modules/system/core/users
    ../../modules/system/core/virtualisation
    ../../modules/system/core/web

    ../../modules/system/apps/steam

    ../../modules/system/desktop/session
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
