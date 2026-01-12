{ config, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;
      splash_offset = 2;
      preload = [
        config.my.wallpaper
      ];
      wallpaper = [
        ",${config.my.wallpaper}"
      ];
    };
  };
}
