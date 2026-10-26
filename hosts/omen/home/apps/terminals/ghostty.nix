{ pkgs, config, ... }:
{
  programs.ghostty = {
    enable = config.my.terminal.pkg == pkgs.ghostty;
    settings = {
      font-size = config.my.terminal.font-size;
      font-family = "${config.my.font.family.mono}";
      cursor-style = "bar";
      cursor-style-blink = true;
      background = "0D0D0D";
      background-opacity = config.my.desktop.opacity;
      # Adds small delay, but opens new window at home.
      gtk-single-instance = false;
      quit-after-last-window-closed = false;
    };
  };
}
