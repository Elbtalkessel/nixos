_: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;
      splash_offset = 2;
      preload = [ "~/.cache/wallpaper" ];
      wallpaper = [
        ",~/.cache/wallpaper"
      ];
    };
  };
}
