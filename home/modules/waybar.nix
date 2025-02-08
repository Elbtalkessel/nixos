{ pkgs, lib, ... }:
let
  sep = "  ";
  lpad = v: if lib.stringLength v > 0 then sep + v else v;
in
{
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
          "pulseaudio"
          "mpd"
          "custom/sep"
          "network"
          # these may or may not be visible, separator is inside these.
          "bluetooth"
          "battery"
          "backlight"
          # ---
          "custom/sep"
          "clock"
          "custom/sep"
          "hyprland/language"
        ];
        "hyprland/window" = {
          "format" = "{}";
        };
        "hyprland/workspaces" = {
          "disable-scroll" = true;
          "show-special" = true;
          "all-outputs" = true;
          "on-click" = "activate";
          "format" = "{icon}";
          "format-icons" = {
            "1" = "󰬺";
            "2" = "󰬻";
            "3" = "󰬼";
            "4" = "󰬽";
            "5" = "󰬾";
            "6" = "󰬿";
            "7" = "󰭀";
            "8" = "󰭁";
            "9" = "󰭂";
            "10" = "󱓇";
            "active" = "";
            "special" = "";
            "empty" = "";
          };
        };
        "hyprland/language" = {
          "format" = "{} ";
          "format-en" = "🇺🇸";
          "format-ru" = "🏳️‍🌈";
        };
        "tray" = {
          "spacing" = 18;
        };
        bluetooth = {
          format = "{icon}";
          format-disabled = "";
          format-off = lpad "󰂲";
          format-on = "";
          format-connected = lpad "󰂴";
          format-icons = lib.map lpad [
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
          "format" = "{icon} ";
          "tooltip-format" = "{volume}%";
          "format-muted" = "󰝟";
          "format-icons" = lib.imap0 (
            i: _:
            lib.concatStrings [
              " "
              (lib.concatStrings (lib.replicate i "•"))
              (lib.concatStrings (lib.replicate (10 - i) "·"))
            ]
          ) (lib.lists.range 0 10);
          "scroll-step" = 5;
          "on-click" = "pavucontrol";
        };
        "clock" = {
          "format" = "{:%H:%M}";
          "tooltip-format" = "{:%a %d %b %H:%M}";
        };
        "battery" = {
          "format" = "{icon}";
          "tooltip-format" = "{capacity}%";
          "format-icons" = lib.map lpad [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            ""
          ];
        };
        "backlight" = {
          "format" = "{icon}";
          "tooltip-format" = "{percent}%";
          "format-icons" = lib.map lpad [
            "󱩎"
            "󱩏"
            "󱩐"
            "󱩑"
            "󱩒"
            "󱩓"
            "󱩔"
            "󱩕"
            "󱩖"
            ""
          ];
        };
        "custom/sep" = {
          "format" = sep;
          "tooltip" = false;
        };
        mpd = {
          "format" = "{stateIcon}{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}";
          "format-disconnected" = "";
          "format-stopped" = "";
          "interval" = 2;
          "on-click" = "mpc toggle";
          "on-click-right" = "mpc stop";
          "on-scroll-up" = "mpc next";
          "on-scroll-down" = "mpc prev";
          "consume-icons" = {
            "on" = " ";
          };
          "random-icons" = {
            "on" = " ";
          };
          "repeat-icons" = {
            "on" = " ";
          };
          "single-icons" = {
            "on" = " 1";
          };
          "state-icons" = {
            "paused" = "";
            "playing" = "";
          };
          "tooltip-format" = "{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
          "tooltip-format-disconnected" = "MPD Disconnected";
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
    '';
  };
}
