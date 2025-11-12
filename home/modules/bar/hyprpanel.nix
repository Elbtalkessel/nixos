{ config, lib, ... }:
{
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
              "media"
              "workspaces"
            ];
            "middle" = [
              "windowtitle"
            ];
            "right" = [
              "systray"
              "battery"
              "volume"
              "bluetooth"
              "network"
              "clock"
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

      "theme.bar.transparent" = true;
      "theme.bar.buttons.background_opacity" = 40;
      "theme.bar.buttons.monochrome" = false;
      "theme.bar.buttons.background" = "#241f31";
      "theme.bar.buttons.style" = "split";
      "theme.bar.buttons.icon_background" = "#242438";
      "theme.bar.menus.border.size" = "0.13em";
      "theme.bar.menus.border.radius" = "0.7em";
      "theme.bar.floating" = false;
      "theme.bar.buttons.borderSize" = "0.1em";
      "theme.bar.buttons.enableBorders" = false;
      "theme.bar.border.location" = "none";
      "theme.bar.border.width" = "0.15em";
      "theme.bar.enableShadow" = false;
      "theme.bar.border_radius" = "0.4em";
      "theme.bar.outer_spacing" = "0";
      "theme.bar.buttons.y_margins" = "0.1em";
      "theme.bar.buttons.padding_x" = "0.7rem";
      "theme.bar.buttons.padding_y" = "0rem";
      "theme.bar.buttons.radius" = "0.5em";
      "theme.bar.buttons.innerRadiusMultiplier" = "0.4";
      "theme.bar.margin_top" = "0.4em";
      "bar.autoHide" = "never";
      "theme.bar.buttons.spacing" = "0.25em";
      "theme.bar.buttons.windowtitle.background" = "#000000";
      "bar.customModules.microphone.label" = true;
      "theme.bar.buttons.modules.microphone.enableBorder" = false;
      "menus.dashboard.powermenu.avatar.image" = "/home/risus/Pictures/PFP/abstract-artwork.jpg";
      "menus.dashboard.shortcuts.enabled" = false;
      "menus.dashboard.directories.enabled" = false;
      "theme.bar.menus.menu.dashboard.profile.radius" = "5em";
      "theme.matugen" = false;
      "theme.bar.menus.menu.dashboard.background.color" = "#241f31";
      "theme.bar.menus.menu.dashboard.border.color" = "#241f31";
      "theme.bar.menus.menu.dashboard.card.color" = "#241f31";
      "theme.bar.menus.menu.clock.background.color" = "#241f31";
      "theme.bar.menus.menu.clock.border.color" = "#241f31";
      "theme.bar.menus.menu.clock.card.color" = "#241f31";
      "theme.bar.menus.menu.battery.text" = "#241f31";
      "theme.bar.menus.menu.battery.card.color" = "#241f31";
      "theme.bar.menus.menu.battery.background.color" = "#241f31";
      "theme.bar.menus.menu.bluetooth.card.color" = "#241f31";
      "theme.bar.menus.menu.bluetooth.background.color" = "#241f31";
      "theme.bar.menus.menu.bluetooth.border.color" = "#241f31";
      "theme.bar.menus.menu.media.background.color" = "#241f31";
      "theme.bar.menus.menu.media.border.color" = "#241f31";
      "theme.bar.menus.menu.media.card.color" = "#241f31";
      "theme.bar.menus.menu.volume.card.color" = "#241f31";
      "theme.bar.menus.menu.volume.background.color" = "#241f31";
      "theme.bar.menus.menu.volume.border.color" = "#241f31";
      "theme.bar.menus.menu.systray.dropdownmenu.background" = "#241f31";
      "theme.bar.menus.menu.systray.dropdownmenu.divider" = "#241f31";
      "theme.bar.menus.menu.network.card.color" = "#241f31";
      "theme.bar.menus.menu.network.background.color" = "#241f31";
      "theme.bar.menus.menu.network.border.color" = "#241f31";
      "theme.bar.menus.border.color" = "#241f31";
      "theme.bar.menus.monochrome" = false;
      "wallpaper.enable" = false;
      "scalingPriority" = "gdk";
      "menus.transition" = "crossfade";
      "theme.notification.background" = "#241f31";
      "theme.font.name" = "Overpass Nerd Font";
      "theme.font.label" = "Overpass Nerd Font Ultra-Light";
      "theme.bar.layer" = "top";
      "theme.bar.buttons.dashboard.enableBorder" = false;
      "bar.workspaces.monitorSpecific" = false;
      "bar.workspaces.show_icons" = false;
      "bar.workspaces.show_numbered" = true;
      "bar.workspaces.workspaceMask" = false;
      "bar.workspaces.showWsIcons" = false;
      "bar.workspaces.showApplicationIcons" = false;
      "bar.volume.label" = false;
      "bar.network.label" = false;
      "bar.bluetooth.label" = false;
      "theme.bar.buttons.bluetooth.spacing" = "0.8em";
      "theme.bar.buttons.network.spacing" = "0.8em";
      "bar.network.truncation_size" = 8;
      "theme.bar.buttons.battery.spacing" = "0.8em";
      "bar.battery.label" = true;
      "bar.battery.hideLabelWhenFull" = true;
      "theme.bar.buttons.systray.enableBorder" = false;
      "bar.clock.showIcon" = false;
      "theme.bar.buttons.media.spacing" = "0.8em";
      "bar.media.show_active_only" = true;
      "theme.bar.buttons.notifications.spacing" = "0.8em";
      "bar.clock.format" = "%a %b %d  %I:%M %p";
      "theme.bar.menus.opacity" = 100;
      "theme.bar.buttons.opacity" = 80;
      "theme.bar.buttons.background_hover_opacity" = 100;
      "theme.bar.opacity" = 100;
      "theme.bar.background" = "#11111b";
      "theme.bar.buttons.dashboard.background" = "#241f31";
      "theme.bar.buttons.volume.background" = "#241f31";
      "theme.bar.buttons.volume.icon_background" = "#241f31";
      "bar.layouts" = {
        "*" = {
          "left" = [
            "dashboard"
            "media"
            "workspaces"
          ];
          "middle" = [
            "windowtitle"
          ];
          "right" = [
            "systray"
            "battery"
            "volume"
            "bluetooth"
            "network"
            "clock"
            "notifications"
          ];
        };
      };
    };
  };
}
