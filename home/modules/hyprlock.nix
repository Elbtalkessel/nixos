_: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        grace = 30;
        hide_cursor = true;
        no_fade_in = false;
        ignore_empty_input = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 10;
        }
      ];

      label = [
        # Day
        {
          text = ''cmd[update:1000] echo -e "$(date +"%A")"'';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 90;
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        # Date-Month
        {
          text = ''cmd[update:1000] echo -e "$(date +"%d %B")"'';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 40;
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          text = ''cmd[update:1000] echo "<span>$(date +"- %I:%M -")</span>"'';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 20;
          position = "0, 190";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          text = "$USER";
          color = "rgba(216, 222, 233, 0.80)";
          font_size = 18;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      # Profie-Photo
      image = {
        path = "${../../assets/profpic.jpg}";
        border_size = 2;
        border_color = "rgba(0, 0, 0, .65)";
        size = 130;
        rounding = -1;
        rotate = 0;
        reload_time = -1;
        position = "0, 40";
        halign = "center";
        valign = "center";
      };

      input-field = [
        {
          size = "300, 60";
          outline_thickness = 2;
          # Scale of input-field height, 0.2 - 0.8
          dots_size = 0.2;
          # Scale of dots' absolute size, 0.0 - 1.0
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(255, 255, 255, 0)";
          inner_color = "rgba(0, 0, 0, 0.75)";
          font_color = "rgb(255, 255, 255)";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##ffffff99">Enter Password</span>'';
          hide_input = false;
          position = "0, -210";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
