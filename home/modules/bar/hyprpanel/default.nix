{ pkgs, ... }:
{
  # https://github.com/Jas-SinghFSU/HyprPanel?tab=readme-ov-file#optional
  home.packages = with pkgs; [
    brightnessctl
    pywal
    grimblast
    wf-recorder
    hyprpicker
    hyprsunset
    btop
    mutagen
    swww
  ];
  # TODO:
  #   - Use config.my.
  #   - Split into modules.
  #   - Automate unblocking config.json
  #     Maybe a wrapper script that will change ~/.config/hyprpanel/config.json from
  #     a symlink to a regualar file. After script exit translate
  #     updated config file into nix and prompt user to rebuild system
  #     removing current config.json.
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    settings = {
      "theme.font.name" = "OverpassM Nerd Font";
      "theme.font.label" = "OverpassM Nerd Font";
      "theme.font.size" = "1rem";
      "menus.transition" = "none";
      "bar.layouts" = {
        "0" = {
          "left" = [
            "workspaces"
            "clock"
          ];
          "middle" = [
            "windowtitle"
            "media"
          ];
          "right" = [
            "volume"
            "network"
            "bluetooth"
            "battery"
            "notifications"
            "dashboard"
            "kbinput"
          ];
        };
      };
      "theme.bar.floating" = false;
      "theme.bar.margin_top" = "0";
      "theme.bar.margin_sides" = "0";
      "theme.bar.margin_bottom" = "0";
      "bar.launcher.autoDetectIcon" = true;
      "bar.workspaces.monitorSpecific" = false;
      "bar.workspaces.show_icons" = false;
      "bar.workspaces.show_numbered" = true;
      "bar.workspaces.workspaces" = 10;
      "bar.volume.label" = false;
      "bar.network.label" = true;
      "bar.network.truncation" = false;
      "bar.bluetooth.label" = false;
      "bar.battery.hideLabelWhenFull" = true;
      "theme.bar.buttons.systray.enableBorder" = false;
      "bar.clock.format" = "%I:%M %p";
      "bar.clock.showIcon" = false;
      "bar.clock.showTime" = true;
      "bar.media.show_label" = true;
      "bar.media.show_active_only" = true;
      "bar.media.truncation" = true;
      "bar.notifications.hideCountWhenZero" = true;
      "theme.notification.enableShadow" = true;
      "notifications.showActionsOnHover" = false;
      "menus.volume.raiseMaximumVolume" = true;
      "menus.clock.time.military" = true;
      "menus.clock.weather.enabled" = false;
      "menus.clock.weather.unit" = "metric";
      "bar.customModules.storage.paths" = [
        "/"
      ];
      "theme.bar.menus.monochrome" = true;
      "theme.bar.menus.border.size" = "0.1em";
      "theme.bar.transparent" = false;
      "theme.bar.opacity" = 50;
      "theme.bar.buttons.background_opacity" = 0;
      "theme.bar.buttons.monochrome" = false;
      "theme.bar.outer_spacing" = "0";
      "theme.bar.buttons.y_margins" = "0";
      "theme.bar.scaling" = 85;
      "theme.tooltip.scaling" = 85;
      "theme.bar.menus.popover.scaling" = 75;
      "theme.bar.menus.switch.radius" = "5em";
      "theme.bar.menus.switch.slider_radius" = "5em";
      "theme.bar.menus.slider.slider_radius" = "5rem";
      "theme.bar.menus.slider.progress_radius" = "5rem";
      "theme.bar.menus.scroller.radius" = "0.7em";
      "theme.bar.menus.progressbar.radius" = "5rem";
      "theme.bar.menus.buttons.radius" = "0.7em";
      "theme.bar.buttons.opacity" = 100;
      "theme.bar.buttons.background_hover_opacity" = 100;
      "menus.dashboard.powermenu.avatar.image" = "/home/risus/Pictures/Horny/cheeky-schoolgirl.jpg";
      "theme.bar.menus.menu.dashboard.profile.radius" = "5em";
      "theme.bar.menus.menu.dashboard.scaling" = 85;
      "bar.windowtitle.custom_title" = false;
      "theme.bar.buttons.windowtitle.enableBorder" = false;
      "bar.windowtitle.class_name" = false;
      "bar.windowtitle.label" = true;
      "bar.windowtitle.icon" = false;
      "wallpaper.enable" = false;
      "theme.bar.menus.border.radius" = "0.7em";
      "theme.bar.buttons.spacing" = "0";
      "theme.bar.buttons.padding_x" = "0.34rem";
      "bar.battery.label" = false;
      "menus.dashboard.shortcuts.left.shortcut1.icon" = "";
      "menus.dashboard.shortcuts.left.shortcut1.command" = "";
      "menus.dashboard.shortcuts.left.shortcut1.tooltip" = "";
      "menus.dashboard.shortcuts.left.shortcut2.icon" = "";
      "menus.dashboard.shortcuts.left.shortcut2.command" = "";
      "menus.dashboard.shortcuts.left.shortcut2.tooltip" = "";
      "menus.dashboard.shortcuts.left.shortcut3.icon" = "";
      "menus.dashboard.shortcuts.left.shortcut3.command" = "";
      "menus.dashboard.shortcuts.left.shortcut3.tooltip" = "";
      "menus.dashboard.shortcuts.left.shortcut4.tooltip" = "";
      "menus.dashboard.shortcuts.right.shortcut1.icon" = "";
      "menus.dashboard.shortcuts.left.shortcut4.command" = "";
      "menus.dashboard.shortcuts.left.shortcut4.icon" = "";
      "menus.dashboard.powermenu.avatar.name" = "system";
      "theme.bar.menus.menu.dashboard.profile.size" = "11em";
      "menus.dashboard.directories.enabled" = false;
      "menus.dashboard.powermenu.sleep" = "systemctl suspend";
      "menus.dashboard.powermenu.logout" = "hyprctl dispatch exit";
      "menus.dashboard.powermenu.reboot" = "systemctl reboot";
      "menus.dashboard.powermenu.shutdown" = "systemctl poweroff";
      "theme.bar.menus.background" = "#1a1a1a";
      "theme.bar.menus.cards" = "#1a1a1a";
      "theme.bar.menus.text" = "#cdd6f4";
      "theme.bar.buttons.style" = "default";
      "theme.bar.buttons.icon_background" = "#242438";
      "theme.bar.menus.buttons.default" = "#b4befe";
      "theme.bar.menus.iconbuttons.passive" = "#cdd6f3";
      "theme.bar.menus.iconbuttons.active" = "#b4beff";
    };
  };
}
