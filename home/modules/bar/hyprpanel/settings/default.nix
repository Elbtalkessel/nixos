{ config, ... }:
# https://arsmoriendy.github.io/GruvboxHSL/
let
  palette = config.my.theme.color.dark;
  transparent = true;
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
          "media"
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
      format = " ";
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
        color = palette.fg;
        location = "full";
        width = if transparent then "0" else "0.03em";
      };
      border_radius = "0.3em";
      buttons = {
        background = palette.bg-primary;
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
        icon = palette.fg-secondary;
        icon_background = palette.bg-primary;
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
        text = palette.fg-secondary;
        volume = {
          enableBorder = false;
          spacing = "0.5em";
        };
        windowtitle = {
          enableBorder = false;
          spacing = "0.5em";
        };
        workspaces = {
          active = palette.bg-primary-container;
          available = palette.bg-secondary-container;
          border = palette.bg-primary-container;
          hover = palette.bg-primary-container;
          numbered_active_underline_color = palette.bg-primary-container;
          occupied = palette.bg-secondary-container;
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
        background = palette.bg-surface;
        border = {
          color = palette.fg;
          radius = "0.7rem";
          size = "0.1em";
        };
        buttons = {
          default = palette.bg-primary-container;
          radius = "1em";
        };
        card_radius = "0.5em";
        cards = palette.bg-surface;
        check_radio_button = {
          active = palette.fg-primary;
        };
        dimtext = palette.fg-secondary;
        dropdownmenu = {
          divider = palette.bg-surface;
          text = palette.fg-surface;
        };
        enableShadow = false;
        feinttext = palette.fg-secondary;
        iconbuttons = {
          active = palette.bg-primary-container;
          passive = palette.bg-secondary-container;
        };
        icons = {
          active = palette.bg-secondary-container;
        };
        label = palette.fg-secondary;
        listitems = {
          active = palette.fg-primary;
        };
        menu = {
          dashboard = {
            profile = {
              radius = "0.7rem";
              size = "15em";
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
              divider = palette.bg-surface;
              text = palette.fg-surface;
            };
          };
        };
        monochrome = true;
        opacity = 98;
        popover = {
          scaling = 75;
          text = palette.fg-surface;
        };
        progressbar = {
          foreground = palette.fg-primary;
          radius = "5rem";
        };
        scroller = {
          radius = "0.7em";
        };
        slider = {
          primary = palette.bg-primary-container;
          progress_radius = "0.2rem";
          puck = palette.fg-primary;
          slider_radius = "0.2rem";
        };
        switch = {
          enabled = palette.bg-primary-container;
          radius = "5em";
          slider_radius = "5em";
        };
        text = palette.fg-secondary;
        tooltip = {
          text = palette.fg-secondary;
        };
      };
      opacity = 90;
      outer_spacing = "0em";
      scaling = 100;
      inherit transparent;
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
        background = palette.bg-secondary-container;
      };
      background = palette.bg-secondary;
      border = palette.fg-secondary;
      close_button = {
        background = palette.bg-secondary-container;
        label = palette.fg-secondary-container;
      };
      enableShadow = true;
      label = palette.fg-secondary;
      labelicon = palette.fg-secondary;
      opacity = 100;
      text = palette.fg-secondary;
      time = palette.fg-secondary;
    };
    osd = {
      bar_color = palette.fg-primary;
      bar_empty_color = palette.bg-surface;
      border = {
        color = palette.bg-surface;
      };
      icon_container = palette.bg-primary-container;
      label = palette.fg-primary;
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
