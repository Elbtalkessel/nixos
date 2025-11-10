{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = config.my.terminal == pkgs.alacritty;

    settings = {
      font = {
        normal = {
          family = config.my.font-family-mono;
          style = "Regular";
        };
        size = 17;
        offset = {
          x = 0;
          y = 10;
        };
      };

      cursor = {
        style = {
          shape = "Beam";
          blinking = "always";
        };
        vi_mode_style = {
          shape = "Beam";
        };
      };

      window = {
        decorations = "full";
        opacity = 0.76;
        padding = {
          x = 0;
          y = 0;
        };
      };

      colors = {
        primary = {
          background = "#0D0D0D";
        };
      };
    };
  };
}
