# Values for my.font -- see ../options/fonts.nix for the declarations.
{ pkgs, ... }:
{
  config.my.font = {
    family = {
      mono = "OverpassM Nerd Font Mono";
      default = "OverpassM Nerd Font";
      propo = "OverpassM Nerd Propo";
    };
    packages = with pkgs; [
      nerd-fonts.overpass
      noto-fonts-color-emoji
    ];
  };
}
