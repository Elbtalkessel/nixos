_: {
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default = <same as gui>
    settings = {
      "bar" = {
        "launcher" = {
          "autoDetectIcon" = true;
        };

        "layouts" = {
          "*" = {
            "left" = [
              "dashboard"
              "workspaces"
            ];
            "middle" = [
              "windowtitle"
            ];
            "right" = [
              "systray"
              "media"
              "volume"
              "bluetooth"
              "network"
              "clock"
              "battery"
              "notifications"
            ];
          };
        };

        "workspaces" = {
          "show_icons" = true;
        };
      };

      "menus" = {
        "clock" = {
          "time" = {
            "hideSeconds" = true;
            "military" = true;
          };

          "weather" = {
            "unit" = "metric";
          };
        };

        "dashboard" = {
          "directories" = {
            "enabled" = true;
          };
          "stats" = {
            "enable_gpu" = false;
          };
        };
      };

      "theme" = {
        "bar" = {
          "transparent" = true;
        };
        "font" = {
          "name" = "OverpassM Nerd Font";
          "size" = "15px";
        };
      };
    };
  };
}
