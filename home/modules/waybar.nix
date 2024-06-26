{ pkgs, ... }:
{
  programs.waybar.enable = true;
  programs.waybar.settings = [{
    "layer" = "top";
    "position" = "top";
    "mod" = "dock";
    "exclusive" = true;
    "passthrough" = false;
    "gtk-layer-shell" = true;
    "height" = 0;
    "modules-left" = [
      "hyprland/workspaces"
      "custom/sep"
      "hyprland/language"
      "custom/sep"
      "hyprland/window"
    ];
    "modules-center" = [];
    "modules-right" = [
      "tray"
      "custom/sep"
      "network"
      "custom/sep"
      "custom/ipaddr"
      "custom/sep"
      "bluetooth"
      "custom/sep"
      "pulseaudio"
      "custom/sep"
      "battery"
      "custom/sep"
      "backlight"
      "custom/sep"
      "clock"
    ];
    "hyprland/window" = {
      "format" = "{}";
    };
    "hyprland/workspaces" = {
      "disable-scroll" = true;
      "all-outputs" = true;
      "on-click" = "activate";
      "persistent_workspaces" = {
        "1" = [];
        "2" = [];
        "3" = [];
        "4" = [];
        "5" = [];
        "6" = [];
        "7" = [];
        "8" = [];
        "9" = [];
        "10" = [];
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
    "custom/ipaddr" = {
      "format" = "󰩟 {}";
      "exec" = "curl ipinfo.io/ip";
      "signal" = 8;
    };
    "battery" = {
      "format" = " {}%";
    };
    "backlight" = {
      "format" = "󱩎 {}%";
    };
    "custom/sep" = {
      "format" = "|";
    };
  }];

  programs.waybar.style = ''
    * {
      font-family: "OverpassM Nerd Font Propo";
      font-size: 16px;
    }
    window#waybar {
      background: rgba(21, 18, 27, 0);
      color: #a89984;
      margin: 10px 0;
    }

    /* for occupied, because .empty is specified */
    #workspaces button {
      padding: 5px;
      color: #d5c5a1;
      margin-right: 5px;
    }

    #workspaces button.empty {
      color: #665c54;
    }

    #workspaces button.active {
      color: #a6adc8;
    }

    #workspaces button.focused {
      color: #fbf1c7;
      background: #282828;
      border-radius: 10px;
    }

    #workspaces button.urgent {
      color: #11111b;
      background: #a6e3a1;
      border-radius: 10px;
    }

    #workspaces button:hover {
      background: #11111b;
      color: #cdd6f4;
      border-radius: 10px;
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
      margin: 0 5px;
    }

    #network {
      color: #fe8019;
    }

    #bluetooth {
      color: #83a594;
    }

    #pulseaudio {
      color: #d3869d;
    }

    #battery {
      color: #8ec07c;
    }

    #brightness {
      color: #fabd2f;
    }

    #clock {
      color: #ebdbb2;
    }

    #custom-sep {
      color: #443c30;
    }
  '';
}

