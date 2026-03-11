{ config, ... }:
let
  p = config.my.theme.color.dark;
in
# css
''
  * {
    font-family: "OverpassM Nerd Font Propo";
    font-size: 18px;
  }

  window#waybar {
    border-radius: 5px;
    background: rgba(13, 13, 13, 0.5);
    color: ${p.fg-secondary};
  }

  #workspaces button {
    padding: 0px 10px;
    opacity: 0.6;
    border-radius: 0;
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
    border-bottom: 1px solid ${p.fg-secondary};
    opacity: 1;
  }

  #mpd,
  #pulseaudio,
  #network,
  #battery,
  #bluetooth,
  #backlight,
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
