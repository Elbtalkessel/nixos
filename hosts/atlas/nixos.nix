{ lib, ... }:
{
  imports = [
    ./config.nix

    ../../modules/system/core

    ./system/boot
    ./system/web
    ./system/microvm
    ./system/users
    ./system/services
    ./system/networking
    ./system/programs
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # A new host, so start at the release the system is actually built from.
  system.stateVersion = "26.11";
}
