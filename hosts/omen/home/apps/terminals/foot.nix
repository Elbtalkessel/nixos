{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.foot = {
    enable = config.my.apps.terminal.pkg == pkgs.foot;
    package = config.my.apps.terminal.pkg;
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
        alpha = config.my.desktop.opacity;
        background = "0D0D0D";
        blur = true;
      };
      bell = {
        system = false;
      };
    };
  };
}
