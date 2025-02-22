_: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "${../../assets/bg.jpg}"
      ];

      wallpaper = [
        ",${../../assets/bg.jpg}"
      ];
    };
  };
}
