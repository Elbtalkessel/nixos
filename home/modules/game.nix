{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (bottles.override { removeWarningPopup = true; })
    discord
    winetricks
    # native wayland support (unstable), there are a number
    # of other variants, see https://nixos.wiki/wiki/Wine
    wineWowPackages.waylandFull
  ];
}
