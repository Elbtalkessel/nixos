_: ''
  * {
    font-family: "OverpassM Nerd Font Propo";
  }

  window#waybar {
    font-size: 16px;
    border-radius: 5px;
    background: rgba(13, 13, 13, 0.5);
  }

  #workspaces button {
    font-size: 25px;
    padding: 0px 5px;
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
