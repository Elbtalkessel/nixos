_: {
  services.wayle.settings.bar = {
    background-opacity = 50;
    border-width = 0;
    button-bg-opacity = 0;
    button-group-opacity = 0;
    button-icon-size = 0.75;
    button-rounding = "none";
    button-variant = "basic";
    layout = [
      {
        center = [ "window-title" ];
        left = [
          "hyprland-workspaces"
          "clock"
          "weather"
        ];
        monitor = "*";
        right = [
          "systray"
          "volume"
          "network"
          "bluetooth"
          "battery"
          "dashboard"
          "keyboard-input"
        ];
        show = true;
      }
    ];
    location = "bottom";
    module-gap = 0;
    padding = 0;
    padding-ends = 0;
    scale = 0.85;
  };
}
