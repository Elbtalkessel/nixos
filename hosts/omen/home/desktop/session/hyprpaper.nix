{ config, ... }:
{
  services.hyprpaper = {
    enable = config.my.wm.bar.provider != "noctalia";
    settings = {
      ipc = true;
      splash = false;
      splash_offset = 2;
      preload = [
        config.my.wallpaper.path
      ];
      wallpaper = [
        ",${config.my.wallpaper.path}"
      ];
    };
  };
}
