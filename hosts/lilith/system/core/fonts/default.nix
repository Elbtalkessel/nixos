{ config, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = config.my.font.packages ++ [
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
          config.my.font.family.mono
          "NotoSansM Nerd Mono"
        ];
        sansSerif = [
          config.my.font.family.default
          "NotoSansM Nerd Font"
        ];
        serif = [
          config.my.font.family.default
          "NotoSansM Nerd Propo"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
