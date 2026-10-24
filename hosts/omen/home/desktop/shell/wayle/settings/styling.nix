{ config, ... }:
let
  palette = config.my.theme.color.dark;
in
{
  services.wayle.settings.styling = {
    palette = {
      bg = palette.bg-primary;
      blue = palette.green-100;
      elevated = palette.bg-surface;
      fg = palette.fg-surface;
      fg-muted = palette.fg-secondary;
      green = palette.green-200;
      primary = palette.fg-secondary;
      red = palette.fg-error;
      surface = palette.bg-primary;
      yellow = palette.fg-tertiary;
    };
    rounding = "md";
    wallust-backend = "resized";
    wallust-colorspace = "lab";
    wallust-palette = "softlight";
    wallust-saturation = 100;
  };
}
