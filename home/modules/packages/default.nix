{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./shellpkgs.nix
    ./flatpak.nix
  ];
}
