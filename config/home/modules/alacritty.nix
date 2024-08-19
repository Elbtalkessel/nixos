{ lib, ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "OverpassM Nerd Font Mono";
          style = "Regular";
        };
        size = 15;
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
        opacity = 0.96;
        padding = {
          x = 0;
          y = 0;
        };
      };

    };
  };
}
