{ config, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = config.my.core.font.packages ++ [
      pkgs.nerd-fonts.noto
      pkgs.noto-fonts-color-emoji
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
        monospace = [
          config.my.core.font.family.mono
          "NotoSansM Nerd Mono"
        ];
        sansSerif = [
          config.my.core.font.family.default
          "NotoSansM Nerd Font"
        ];
        serif = [
          config.my.core.font.family.default
          "NotoSansM Nerd Propo"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
