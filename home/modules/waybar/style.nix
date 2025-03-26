_: ''
  * {
    font-family: "OverpassM Nerd Font Propo";
    font-size: 16px;
  }

  window#waybar {
    border-radius: 5px;
    background: rgba(13, 13, 13, 0.5);
  }

  #workspaces button {
    padding: 5px 10px;
    opacity: 0.4;
  }

  #workspaces button.empty {
    opacity: 0.4;
  }

  #workspaces button.urgent {
    color: #D84040;
  }

  #workspaces button.active,
  #workspaces button.focused,
  #workspaces button:hover {
    color: #d3d3d3;
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
    opacity: 0.5;
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
