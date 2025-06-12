_: {
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "OverpassM Nerd Font Mono";
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
        opacity = 1;
        padding = {
          x = 0;
          y = 0;
        };
      };

      colors = {
        primary = {
          background = "#2a2d3b";
        };
      };
    };
  };
}
