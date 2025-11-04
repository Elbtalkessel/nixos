{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.overpass
      noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
      subpixel.rgba = "rgb";
      # https://mynixos.com/nixpkgs/option/fonts.fontconfig.hinting.style
      hinting = {
        enable = true;
        style = "slight";
      };
      # https://mynixos.com/nixpkgs/option/fonts.fontconfig.antialias
      antialias = true;
      defaultFonts = {
        monospace = [ "Overpass Nerd Font Mono" ];
        sansSerif = [ "Overpass Nerd Font" ];
        serif = [ "Overpass Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
