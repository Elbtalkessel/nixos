{ pkgs, config, ... }:
{
  fonts = {
    enableDefaultPackages = true;
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
        monospace = [ config.my.font-family-mono ];
        sansSerif = [ config.my.font-family ];
        serif = [ config.my.font-family ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
