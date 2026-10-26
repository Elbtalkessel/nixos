{
  config,
  lib,
  ...
}:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "${config.my.core.font.family.mono}:size=${lib.toString config.my.apps.terminal.font-size}";
        line-height = 25;
      }
      // (
        if config.my.desktop.shell.provider == "noctalia" then
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
