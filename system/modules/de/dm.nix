{ config, ... }: {
  services.displayManager = {
    enable = true;
    autoLogin = {
      # TODO: enable it, but should unlock keyright by itself, if possible.
      enable = false;
      user = config.my.username;
    };
    ly = {
      enable = true;
      x11Support = false;
      # https://github.com/fairyglade/ly/blob/v1.4.1/res/config.ini
      # - Some dur files (blackhole) require full_color to be true.
      settings = {
        animation = "doom";
        full_color = true;
        animation_frame_delay = 40;
        doom_fire_height = 1;
        doom_fire_spread = 4;
        show_tty = true;
        clock = "%F %T";
        hide_version_string = true;
        hide_borders = true;
        brightness_down_cmd = null;
        brightness_down_key = null;
        brightness_up_cmd = null;
        brightness_up_key = null;
      };
    };
  };
}
