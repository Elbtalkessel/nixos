_:
let
  # https://arsmoriendy.github.io/GruvboxHSL/
  monochrome = true;
  autocolor = false;
  wallpaper = "/home/risus/.cache/wallpaper";
  avatar = "/home/risus/.cache/avatar";
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
        ];
        middle = [
          "windowtitle"
        ];
        right = [
          "systray"
          "media"
          "volume"
          "network"
          "battery"
          "bluetooth"
          "notifications"
          "dashboard"
          "kbinput"
          "clock"
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
      icon = true;
      label = true;
    };
    workspaces = {
      applicationIconEmptyWorkspace = "•";
      monitorSpecific = false;
      showApplicationIcons = true;
      showWsIcons = true;
      show_icons = false;
      show_numbered = false;
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
          image = avatar;
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
        color = "#111313";
        location = "full";
        width = "0.03em";
      };
      border_radius = "0.3em";
      buttons = {
        background = "#1d2021";
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
        icon = "#ffffff";
        icon_background = "#1d2021";
        innerRadiusMultiplier = "0";
        media = {
          spacing = "0.35em";
        };
        inherit monochrome;
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
        text = "#ffffff";
        volume = {
          enableBorder = false;
          spacing = "0.5em";
        };
        windowtitle = {
          enableBorder = false;
          spacing = "0.5em";
        };
        workspaces = {
          active = "#f5c2e7";
          available = "#A89984";
          border = "#f5c2e7";
          hover = "#f5c2e7";
          numbered_active_underline_color = "#f5c2e7";
          occupied = "#f2cdcd";
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
        background = "#1d2021";
        border = {
          color = "#111313";
          radius = "0.7rem";
          size = "0.1em";
        };
        buttons = {
          default = "#f9f5d7";
          radius = "0.7em";
        };
        card_radius = "0.5em";
        cards = "#1d2021";
        check_radio_button = {
          active = "#f9f5d7";
        };
        dimtext = "#bdae93";
        dropdownmenu = {
          divider = "#11111b";
          text = "#ffffff";
        };
        enableShadow = false;
        feinttext = "#a89984";
        iconbuttons = {
          active = "#f9f5d7";
          passive = "#cdd6f3";
        };
        icons = {
          active = "#f9f5d7";
        };
        label = "#ffffff";
        listitems = {
          active = "#f9f5d7";
        };
        menu = {
          dashboard = {
            profile = {
              radius = "5em";
              size = "11em";
            };
            scaling = 85;
          };
          systray = {
            dropdownmenu = {
              divider = "#11111b";
              text = "#ffffff";
            };
          };
        };
        inherit monochrome;
        opacity = 98;
        popover = {
          scaling = 75;
          text = "#f9f5d7";
        };
        progressbar = {
          foreground = "#f9f5d7";
          radius = "5rem";
        };
        scroller = {
          radius = "0.7em";
        };
        slider = {
          primary = "#f9f5d7";
          progress_radius = "5rem";
          slider_radius = "5rem";
        };
        switch = {
          enabled = "#f9f5d7";
          radius = "5em";
          slider_radius = "5em";
        };
        text = "#ffffff";
        tooltip = {
          text = "#f9f5d7";
        };
      };
      opacity = 90;
      outer_spacing = "0em";
      scaling = 85;
      transparent = false;
    };
    font = {
      label = "OverpassM Nerd Font Semi-Bold";
      name = "OverpassM Nerd Font";
      size = "1.1rem";
      style = "normal";
      weight = 400;
    };
    matugen = !monochrome && autocolor;
    matugen_settings = {
      scheme_type = "content";
      variation = "standard_3";
    };
    notification = {
      actions = {
        background = "#f9f5d7";
      };
      background = "#282828";
      border = "#1D2021";
      close_button = {
        background = "#EBDBB2";
        label = "#11111b";
      };
      enableShadow = true;
      label = "#ffffff";
      labelicon = "#ffffff";
      opacity = 100;
      text = "#ffffff";
      time = "#ffffff";
    };
    osd = {
      bar_color = "#f9f5d7";
      bar_empty_color = "#241f31";
      border = {
        color = "#f9f5d7";
      };
      icon_container = "#f9f5d7";
      label = "#f9f5d7";
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
    image = wallpaper;
    pywal = false;
  };
}
