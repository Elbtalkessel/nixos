{ pkgs, config, ... }:
{
  programs.ghostty = {
    enable = config.my.terminal.pkg == pkgs.ghostty;
    settings = {
      font-size = 17;
      font-family = "${config.my.font.family.mono}";
      cursor-style = "bar";
      cursor-style-blink = true;
      background = "0D0D0D";
      background-opacity = config.my.opacity;
    };
  };
}
