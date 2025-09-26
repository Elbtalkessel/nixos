{ pkgs, config, ... }:
{
  programs.foot = {
    enable = config.terminal == pkgs.foot;
    package = config.terminal;
    settings = {
      main = {
        font = "${config.font-family-mono}:size=17";
        line-height = 30;
      };
      cursor = {
        style = "beam";
        unfocused-style = "hollow";
        blink = true;
        blink-rate = 800;
      };
      colors = {
        alpha = 0.76;
        background = "0D0D0D";
      };
    };
  };
}
