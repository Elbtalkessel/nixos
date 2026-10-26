# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  modulesPath,
  lib,
  disko,
  config,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    disko.nixosModules.disko
    ./disko.nix
    ./filesystem.nix
    ./config.nix

    ../../modules/system/core

    ./system/apps
    ./system/core
    ./system/desktop
  ];

  networking.hostName = "omen";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/manual/nixos/stable/options).
  system.stateVersion = "23.11"; # Did you read the comment?

  # `kvm` lets the user account talk to /dev/kvm and reach the
  # `microvm:kvm`-owned state directory under /var/lib/microvms, so
  # `microvm -s atlas` and friends work without sudo.
  users.users.${config.my.core.identity.username}.extraGroups = [ "kvm" ];
}
