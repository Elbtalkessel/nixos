{ config, ... }: {
  services.displayManager = {
    enable = true;
    autoLogin = {
      enable = true;
      user = config.my.username;
    };
    ly = {
      enable = true;
      x11Support = false;
      # https://github.com/fairyglade/ly/blob/master/res/config.ini
      settings = {
        animation = "doom";
        animation_frame_delay = 40;
        bigclock = "en";
        hide_borders = true;
        doom_fire_height = 1;
        doom_fire_spread = 4;
        corner_top_left = "shutdown,restart";
        corner_bottom_left = null;
        corner_bottom_right = null;
      };
    };
  };
}
