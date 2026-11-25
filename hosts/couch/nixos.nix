{
  lib,
  disko,
  ...
}:
{
  imports = [
    # Disk layout is declared here and applied by `disko --mode disko` at
    # install time; the module derives fileSystems from it for every later
    # build.
    disko.nixosModules.disko
    ./disko.nix
    ./config.nix

    ../../modules/system/core

    ./system/boot
    ./system/hardware
    ./system/networking
    ./system/security
    ./system/services
    ./system/users
    ./system/desktop
    ./system/power
    ./system/packages
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # A new host, so start at the release the system is actually built from.
  system.stateVersion = "26.11";
}
