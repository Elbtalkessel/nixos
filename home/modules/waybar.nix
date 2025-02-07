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
          "hyprland/language"
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
        "hyprland/language" = {
          # TODO: replace with emoji flags (install the font)
          "format" = "{}";
          "format-en" = "🇺🇸";
          "format-ru" = "🏳️‍🌈";
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
          "format" = "{:%a %d %b %H:%M}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
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
      }

      #workspaces button {
        padding: 5px 10px;
        border-radius: 0px;
      }

      #workspaces button.empty {
        color: #a1a1a1;
      }

      #workspaces button.urgent {
        background: #9bab94;
      }

      #workspaces button.active,
      #workspaces button.focused,
      #workspaces button:hover {
        background: #282828;
        border-bottom: 1px solid #d3d3d3;
        color: #d3d3d3;
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

      #window,
      #clock {
        color: #b3b3b3;
      }


      #bluetooth,
      #battery,
      #pulseaudio,
      #custom-ipaddr,
      #network,
      #backlight {
        color: #c0c0c0;
      }
    '';
  };
}
