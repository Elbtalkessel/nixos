_: {
  programs.waybar = {
    enable = true;
    settings = [
      {
        "layer" = "top";
        "position" = "top";
        "mode" = "dock";
        "exclusive" = true;
        "passthrough" = false;
        "gtk-layer-shell" = true;
        "height" = 0;
        "margin-top" = 4;
        "margin-left" = 4;
        "margin-right" = 4;
        "modules-left" = [
          "hyprland/workspaces"
          "custom/sep"
          "hyprland/language"
          "custom/sep"
          "hyprland/window"
        ];
        "modules-center" = [ ];
        "modules-right" = [
          "tray"
          "custom/sep"
          "network"
          "bluetooth"
          "pulseaudio"
          "battery"
          "backlight"
          "clock"
        ];
        "hyprland/window" = {
          "format" = "{}";
        };
        "hyprland/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          "on-click" = "activate";
          "persistent-workspaces" = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
            "10" = [ ];
          };
          "format" = "{icon}";
          "format-icons" = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
          };
        };
        "tray" = {
          "spacing" = 5;
        };
        "network" = {
          "interface" = "wlo1";
          "format" = " {ifname}";
          "format-wifi" = " {ipaddr} ({signalStrength}%)";
          "format-ethernet" = "{ipaddr}/{cidr}";
          "format-disconnected" = ""; # An empty format will hide the module.
          "tooltip-format" = "{ifname} via {gwaddr}";
          "tooltip-format-wifi" = "{essid} ({signalStrength}%)";
          "tooltip-format-ethernet" = "{ifname}";
          "tooltip-format-disconnected" = "Disconnected";
          "max-length" = 50;
        };
        "pulseaudio" = {
          "format" = " {volume}%";
          "tooltip" = "{muted}";
        };
        "clock" = {
          "format" = " {:%a %d %b, %H:%M}";
        };
        "battery" = {
          "format" = " {}%";
        };
        "backlight" = {
          "format" = "󱩎 {}%";
        };
        "custom/sep" = {
          "format" = "";
        };
      }
    ];

    style = ''
      * {
        font-family: "OverpassM Nerd Font Propo";
        font-size: 16px;
      }

      window#waybar,
      #workspaces button {
        border-radius: 0px;
        color: #999999;
      }

      window#waybar {
        background: rgba(21, 18, 27, 0.5);
      }

      #workspaces button {
        padding: 5px 10px;
      }

      #workspaces button.empty {
        color: #7c6f64;
      }

      #workspaces button.urgent {
        background: #89a382;
      }

      #workspaces button.active,
      #workspaces button.focused,
      #workspaces button:hover {
        background: #282828;
        border-bottom: 1px solid #d4be98;
      }

      #workspaces button:hover {
        border-color: #202020;
      }

      #bluetooth,
      #battery,
      #clock,
      #language,
      #workspaces,
      #tray,
      #pulseaudio,
      #custom-ipaddr,
      #network,
      #backlight,
      #window {
        padding: 0 15px;
      }
    '';
  };
}
