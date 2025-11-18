{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # bottles installed using flatpak
    discord
    # escape hatch, bottles is able to install dependencies
    # as well, but the number of those is limited.
    winetricks
    # required for winetricks.
    # native wayland support (unstable), there are a number
    # of other variants, see https://nixos.wiki/wiki/Wine
    wineWowPackages.waylandFull
  ];
}
