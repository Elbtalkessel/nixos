_: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;
      splash_offset = 2.0;
      preload = [ "~/.cache/wallpaper" ];
      wallpaper = [
        ",~/.cache/wallpaper"
      ];
    };
  };
}
