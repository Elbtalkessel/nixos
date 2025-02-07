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
        "margin-top" = 0;
        "margin-left" = 0;
        "margin-right" = 0;
        "modules-left" = [
          "hyprland/workspaces"
          "custom/sep"
          "hyprland/language"
        ];
        "modules-center" = [
          "hyprland/window"
        ];
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
        bluetooth = {
          format = "{icon}";
          format-disabled = "";
          format-off = "󰂲";
          format-on = "󰂯";
          format-connected = "󰂴";
          format-icons = [
            "󰤾"
            "󰤿"
            "󰥀"
            "󰥁"
            "󰥂"
            "󰥃"
            "󰥄"
            "󰥅"
            "󰥆"
            "󰥈"
          ];
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };
        "network" = {
          "interface" = "wlo1";
          "format" = "";
          "format-wifi" = "";
          "format-ethernet" = "󰈀";
          "format-disconnected" = "";
          "tooltip-format" = "{ifname} via {gwaddr}";
          "tooltip-format-wifi" = "{ipaddr} @ {essid} ({signalStrength}%)";
          "tooltip-format-ethernet" = "{ipaddr}/{cidr}";
          "tooltip-format-disconnected" = "Disconnected";
          "max-length" = 50;
        };
        "pulseaudio" = {
          "format" = "{icon}";
          "tooltip-format" = "{volume}%";
          "format-muted" = "󰝟";
          "format-icons" = [
            ""
            ""
            ""
          ];
          "scroll-step" = 5;
          "on-click" = "pavucontrol";
        };
        "clock" = {
          "format" = " {:%a %d %b, %H:%M}";
        };
        "battery" = {
          "format" = "{icon}";
          "tooltip-format" = "{capacity}%";
          "format-icons" = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        "backlight" = {
          "format" = "{icon}";
          "tooltip-format" = "{percent}%";
          "format-icons" = [
            "󱩎"
            "󱩏"
            "󱩐"
            "󱩑"
            "󱩒"
            "󱩓"
            "󱩔"
            "󱩕"
            "󱩖"
            "󰛨"
          ];
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

      window#waybar {
        background: rgba(13, 13, 13, 0.5);
        border-radius: 5px;
        color: #868686;
      }

      #workspaces button {
        padding: 5px 10px;
        color: #999999;
        border-radius: 0px;
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
        color: #d4be98;
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
        padding: 0 10px;
      }

      #bluetooth { color: rgba(79, 195, 247, 0.7); }
      #battery { color: rgba(129, 212, 250, 0.7); }
      #network { color: rgba(41, 182, 246, 0.7); }
      #clock { color: rgba(255, 183, 77, 0.7); }
      #language { color: rgba(204, 136, 68, 0.7); }
      #workspaces { color: rgba(224, 224, 224, 0.7); }
      #pulseaudio { color: rgba(179, 157, 219, 0.7); }
      #backlight { color: rgba(149, 117, 205, 0.7); }
      #tray { color: rgba(129, 199, 132, 0.7); }
      #custom-ipaddr { color: rgba(102, 187, 106, 0.7); }
    '';
  };
}
