{ config, ... }:
# https://arsmoriendy.github.io/GruvboxHSL/
let
  dark-900 = "#111313";
  dark-800 = "#1d2021";
  light-900 = "#ffffff";
  light-700 = "#cccccc";
  urgent = "#f5c2e7";
  accent = "#FF8FB7";
  highlight = "#f9f5d7";
in
{
  bar = {
    battery = {
      hideLabelWhenFull = true;
      label = false;
    };
    bluetooth = {
      label = false;
    };
    clock = {
      format = "%I:%M %p";
      showIcon = false;
      showTime = true;
    };
    customModules = {
      storage = {
        paths = [ "/" ];
      };
    };
    launcher = {
      autoDetectIcon = false;
      icon = "";
    };
    layouts = {
      "0" = {
        left = [
          "workspaces"
          "clock"
        ];
        middle = [ "windowtitle" ];
        right = [
          "volume"
          "network"
          "battery"
          "bluetooth"
          "notifications"
          "dashboard"
          "kbinput"
        ];
      };
    };
    media = {
      format = "{title}";
      show_active_only = true;
      show_label = true;
      truncation = true;
      truncation_size = 20;
    };
    network = {
      label = false;
      truncation = false;
    };
    notifications = {
      hideCountWhenZero = true;
    };
    systray = {
      customIcons = { };
      ignore = [ ];
    };
    volume = {
      label = false;
    };
    windowtitle = {
      class_name = false;
      custom_title = false;
      icon = false;
      label = true;
      # https://hyprpanel.com/configuration/panel.html#window-title-mappings
      # [<title> <icon> <new title>]
      title_map = [
        [
          "foot"
          ""
          "Foot Terminal"
        ]
      ];
      truncation_size = 51;
    };
    workspaces = {
      applicationIconEmptyWorkspace = "•";
      # https://hyprpanel.com/configuration/panel.html#map-workspaces-to-application-icons
      applicationIconMap = {
        "class:foot$" = "";
        "title:YouTube" = "";
      };
      monitorSpecific = false;
      showApplicationIcons = true;
      showWsIcons = true;
      show_icons = false;
      show_numbered = false;
      # https://hyprpanel.com/configuration/panel.html#show-workspace-icons
      # <workspace id> = { color = ""; icon = "" };
      workspaceIconMap = { };
      workspaces = 10;
    };
  };
  menus = {
    clock = {
      time = {
        military = true;
      };
      weather = {
        enabled = false;
        unit = "metric";
      };
    };
    dashboard = {
      directories = {
        enabled = false;
      };
      powermenu = {
        avatar = {
          image = config.my.avatar;
          name = "system";
        };
        logout = "hyprctl dispatch exit";
        reboot = "systemctl reboot";
        shutdown = "systemctl poweroff";
        sleep = "systemctl suspend";
      };
      shortcuts = {
        left = {
          shortcut1 = {
            command = "";
            icon = "";
            tooltip = "";
          };
          shortcut2 = {
            command = "";
            icon = "";
            tooltip = "";
          };
          shortcut3 = {
            command = "";
            icon = "";
            tooltip = "";
          };
          shortcut4 = {
            command = "";
            icon = "";
            tooltip = "";
          };
        };
        right = {
          shortcut1 = {
            icon = "";
          };
        };
      };
    };
    media = {
      displayTime = false;
      displayTimeTooltip = false;
      hideAlbum = false;
      hideAuthor = false;
    };
    transition = "crossfade";
    volume = {
      raiseMaximumVolume = false;
    };
  };
  notifications = {
    position = "bottom right";
    showActionsOnHover = false;
  };
  theme = {
    bar = {
      border = {
        color = dark-900;
        location = "full";
        width = "0.03em";
      };
      border_radius = "0.3em";
      buttons = {
        background = dark-800;
        background_hover_opacity = 100;
        background_opacity = 0;
        battery = {
          spacing = "0.35em";
        };
        bluetooth = {
          spacing = "0.35em";
        };
        borderSize = "0.1em";
        clock = {
          spacing = "0.35em";
        };
        icon = light-900;
        icon_background = dark-800;
        innerRadiusMultiplier = "0";
        media = {
          spacing = "0.35em";
        };
        monochrome = true;
        network = {
          spacing = "0.35em";
        };
        notifications = {
          spacing = "0.35em";
        };
        opacity = 98;
        padding_x = "0em";
        padding_y = "0";
        radius = "0";
        separator = {
          margins = "0.15em";
        };
        spacing = "0.5em";
        style = "default";
        systray = {
          enableBorder = false;
        };
        text = light-900;
        volume = {
          enableBorder = false;
          spacing = "0.5em";
        };
        windowtitle = {
          enableBorder = false;
          spacing = "0.5em";
        };
        workspaces = {
          active = urgent;
          available = light-700;
          border = urgent;
          hover = urgent;
          numbered_active_underline_color = urgent;
          occupied = light-900;
        };
        y_margins = "0em";
      };
      enableShadow = false;
      floating = true;
      location = "bottom";
      margin_bottom = "0.2em";
      margin_sides = "0.15em";
      margin_top = "0.2em";
      menus = {
        background = dark-800;
        border = {
          color = dark-900;
          radius = "0.7rem";
          size = "0.1em";
        };
        buttons = {
          default = accent;
          radius = "1em";
        };
        card_radius = "0.5em";
        cards = dark-800;
        check_radio_button = {
          active = accent;
        };
        dimtext = light-700;
        dropdownmenu = {
          divider = dark-800;
          text = light-900;
        };
        enableShadow = false;
        feinttext = light-700;
        iconbuttons = {
          active = accent;
          passive = highlight;
        };
        icons = {
          active = accent;
        };
        label = light-900;
        listitems = {
          active = accent;
        };
        menu = {
          dashboard = {
            profile = {
              radius = "5em";
              size = "11em";
            };
            scaling = 85;
          };
          media = {
            card = {
              tint = 0;
            };
          };
          systray = {
            dropdownmenu = {
              divider = dark-800;
              text = light-900;
            };
          };
        };
        monochrome = true;
        opacity = 98;
        popover = {
          scaling = 75;
          text = accent;
        };
        progressbar = {
          foreground = accent;
          radius = "5rem";
        };
        scroller = {
          radius = "0.7em";
        };
        slider = {
          primary = accent;
          progress_radius = "0.2rem";
          puck = accent;
          slider_radius = "0.2rem";
        };
        switch = {
          enabled = accent;
          radius = "5em";
          slider_radius = "5em";
        };
        text = light-900;
        tooltip = {
          text = accent;
        };
      };
      opacity = 90;
      outer_spacing = "0em";
      scaling = 100;
      transparent = false;
    };
    font = {
      label = "OverpassM Nerd Font Semi-Bold";
      name = "OverpassM Nerd Font";
      size = "1rem";
      style = "normal";
      weight = 400;
    };
    matugen = false;
    matugen_settings = {
      scheme_type = "content";
      variation = "standard_3";
    };
    notification = {
      actions = {
        background = accent;
      };
      background = dark-900;
      border = dark-800;
      close_button = {
        background = accent;
        label = dark-900;
      };
      enableShadow = true;
      label = light-900;
      labelicon = light-900;
      opacity = 100;
      text = light-900;
      time = light-900;
    };
    osd = {
      bar_color = accent;
      bar_empty_color = dark-800;
      border = {
        color = accent;
      };
      icon_container = accent;
      label = accent;
      location = "bottom";
      muted_zero = true;
      opacity = 95;
      orientation = "horizontal";
    };
    tooltip = {
      scaling = 85;
    };
  };
  wallpaper = {
    enable = false;
    image = config.my.wallpaper.path;
    pywal = false;
  };
}
