_:
let
  background = ../../assets/bg.png;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload = [ "${background}" ];
      wallpaper = [ ",${background}" ];
    };
  };
}
