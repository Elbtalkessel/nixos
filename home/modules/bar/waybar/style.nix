{ config, ... }:
let
  p = config.my.theme.color.dark;
in
''
  * {
    font-family: "${config.my.font.family.propo}";
    font-size: 16px;
  }

  window#waybar {
    border-radius: 5px;
    background: rgba(13, 13, 13, 0.0);
    color: ${p.fg-secondary};
  }

  #workspaces button {
    padding: 5px 10px;
    opacity: 0.6;
  }

  #workspaces button.empty {
    opacity: 0.3;
  }

  #workspaces button.urgent {
    color: ${p.fg-error};
  }

  #workspaces button.active,
  #workspaces button.focused,
  #workspaces button:hover {
    color: ${p.fg-secondary};
    opacity: 1;
  }

  #mpd,
  #pulseaudio,
  #network,
  #battery,
  #bluetooth,
  #backlight,
  #clock,
  #language
  {
    opacity: 0.7;
  }
  #mpd:hover,
  #pulseaudio:hover,
  #network:hover,
  #battery:hover,
  #bluetooth:hover,
  #backlight:hover,
  #clock:hover,
  #language:hover
  {
    opacity: 1;
  }
''
