{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.foot = {
    enable = config.my.terminal.pkg == pkgs.foot;
    package = config.my.terminal.pkg;
    settings = {
      main = {
        font = "${config.my.font.family.mono}:size=${lib.toString config.my.terminal.font-size}";
        line-height = 25;
      }
      // (
        if config.my.wm.bar.provider == "noctalia" then
          {
            include = "~/.config/foot/themes/noctalia";
          }
        else
          { }
      );
      cursor = {
        style = "beam";
        unfocused-style = "hollow";
        blink = true;
        blink-rate = 800;
      };
      colors-dark = {
        alpha = config.my.opacity;
        background = "0D0D0D";
        blur = true;
      };
    };
  };
}
