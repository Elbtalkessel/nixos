{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # bottles is installed through flatpak
    discord
    # voice client
    mumble
  ];
}
