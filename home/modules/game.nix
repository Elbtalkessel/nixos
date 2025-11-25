{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # bottles installed using flatpak
    discord
  ];
}
