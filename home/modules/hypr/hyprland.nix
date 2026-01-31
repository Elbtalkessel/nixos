{
  pkgs,
  config,
  lib,
  ...
}:
let
  center-rule = domain: classifiers: [
    "match:${domain} (${builtins.concatStringsSep "|" classifiers}),float on,center on"
  ];
  TERMINAL = config.my.terminal.exe;
  M = "SUPER";
  palette = config.my.theme.color.dark;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
    package = null;
    portalPackage = null;
    systemd = {
      # Conflicts with UWSM, see system/modules/session.nix
      enable = false;
      # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
      variables = [ "--all" ];
    };
    settings = {
      monitor = [
        "eDP-1,highres,auto,1"
      ];
      xwayland = {
        enabled = true;
        force_zero_scaling = true;
      };

      # While v2 rules allow multiple rules to be applied, the `center` rule
      # or `move` rule is not available.
      # https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrule =
        (center-rule "initial_class" [
          "org.gnome.Calculator"
          "udiskie"
          "polkit-gnome-authentication-agent-1"
          "solaar"
          "jetbrains-toolbox"
        ])
        ++ (center-rule "initial_title" [
          "Open File"
          "Open Files"
          "Set Background"
        ])
        ++ [
          # no blur for floating window, elector apps render popup menus
          # as a floating window causing a blurred outline around the popup.
          "match:float true, no_blur on"
          "match:initial_class steam_proton, float on"
          "match:title ^SteamTinkerLaunch.*$, float on"
          "match:initial_class ^.*\.exe$, float on"
        ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      "exec-once" = [
        "${lib.getExe pkgs.solaar} --window=hide --battery-icons=symbolic"
        "systemctl --user start hyprland-session.service"
      ];

      # KEY BINDINGS, see https://wiki.hyprland.org/Configuring/Binds/ for more
      # Two hand layout, left is holding modifier, right is presssing a key# Two hand layout, left is holding modifier, right is presssing a key

      # Special
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl -c backlight s +20"
        ", XF86MonBrightnessDown, exec, brightnessctl -c backlight s 20-"
        "${M} CONTROL, H, resizeactive, -25 0"
        "${M} CONTROL, L, resizeactive, 25 0"
        "${M} CONTROL, K, resizeactive, 0 -25"
        "${M} CONTROL, J, resizeactive, 0 25"
      ];
      # MOVE/RESIZE WINDOWS with M + LMB/RMB and dragging
      bindm = [
        "${M}, mouse:272, movewindow"
        "${M}, mouse:273, resizewindow"
      ];
      bind = [
        # Launcher
        "${M}, SPACE, exec, vicinae toggle"
        "${M}, RETURN, exec, ${TERMINAL}"

        # Window management
        "${M}, f, fullscreen,"
        "${M}, delete, killactive,"
        "${M}, backspace, exec, hyprctl --batch 'dispatch togglefloating active; dispatch pin active'"
        "${M} SHIFT, escape, movetoworkspace, special" # move to the special workspace
        "${M}, escape, togglespecialworkspace" # show/hide special workspace

        # MOVE FOCUS with M + arrow keys
        "${M}, H, movefocus, l"
        "${M}, L, movefocus, r"
        "${M}, K, movefocus, u"
        "${M}, J, movefocus, d"

        # MOVE WINDOW with M SHIFT + arrow keys
        "${M} SHIFT, H, movewindow, l"
        "${M} SHIFT, L, movewindow, r"
        "${M} SHIFT, K, movewindow, u"
        "${M} SHIFT, J, movewindow, d"

        # SWITCH WORKSPACES with M + [0-9]
        "${M}, 1, workspace, 1"
        "${M}, 2, workspace, 2"
        "${M}, 3, workspace, 3"
        "${M}, 4, workspace, 4"
        "${M}, 5, workspace, 5"
        "${M}, 6, workspace, 6"
        "${M}, 7, workspace, 7"
        "${M}, 8, workspace, 8"
        "${M}, 9, workspace, 9"
        "${M}, 0, workspace, 10"

        # MOVE ACTIVE WINDOW TO A WORKSPACE with M + SHIFT + [0-9]
        "${M} SHIFT, 1, movetoworkspace, 1"
        "${M} SHIFT, 2, movetoworkspace, 2"
        "${M} SHIFT, 3, movetoworkspace, 3"
        "${M} SHIFT, 4, movetoworkspace, 4"
        "${M} SHIFT, 5, movetoworkspace, 5"
        "${M} SHIFT, 6, movetoworkspace, 6"
        "${M} SHIFT, 7, movetoworkspace, 7"
        "${M} SHIFT, 8, movetoworkspace, 8"
        "${M} SHIFT, 9, movetoworkspace, 9"
        "${M} SHIFT, 0, movetoworkspace, 10"
        "${M}, TAB, workspace, previous"
        "ALT, TAB, cyclenext"
        "ALT, TAB, bringactivetotop"
      ];

      binds = {
        allow_workspace_cycles = true;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 5;
        dim_inactive = true;
        dim_strength = 0.10;
        blur = {
          enabled = !config.my.wm.performance;
          size = 10;
          passes = 2;
          new_optimizations = true;
        };
      };

      layerrule = [
        # Apply rule to a layer
        # https://wiki.hypr.land/Configuring/Keywords/#blurring-layersurfaces
        # vicinae integration
        # https://docs.vicinae.com/quickstart/hyprland
        {
          name = "vicinae-blur";
          blur = "on";
          ignore_alpha = 0;
          no_anim = "on";
          "match:namespace" = "vicinae";
        }
        {
          "match:namespace" = "notifications-window";
          name = "notification-toast";
          blur_popups = "on";
        }
        {
          "match:namespace" = "^[a-z]+menu$";
          name = "bottom-menu-slide-up";
          animation = "slide bottom";
        }
      ];

      # Global animation configuration, controls layer and window animation.
      # NAME you can find here https://wiki.hypr.land/Configuring/Animations/#animation-tree
      # Animation style can be overriden in the window or layer rule set.
      animations = {
        enabled = !config.my.wm.performance;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        # NAME, ON_OFF, SPEED, CURVE, [,STYLE]
        animation = [
          "windows, 1, 1, myBezier"
          "windowsOut, 1, 1, default, popin 80%"
          "border, 1, 2, default"
          "borderangle, 1, 2, default"
          "fade, 1, 1, default"
          "workspaces, 1, 1, default"
          "specialWorkspace, 1, 1, myBezier, slidevert"
          "layers, 1, 1, myBezier, default"
        ];
      };

      # GENERAL SETTINGS
      general =
        let
          color-from = lib.strings.removePrefix "#" palette.fg-primary-container;
          color-to = lib.strings.removePrefix "#" palette.fg-secondary;
          inactive-color = lib.strings.removePrefix "#" palette.fg;
        in
        {
          border_size = 1;
          gaps_in = 3;
          gaps_out = 3;
          "col.active_border" = "rgba(${color-from}ee) rgba(${color-to}ee) 45deg";
          "col.inactive_border" = "rgba(${inactive-color}aa)";
          layout = "dwindle";
          extend_border_grab_area = true;
          hover_icon_on_border = true;
        };

      # DWINDLE LAYOUT
      dwindle = {
        pseudotile = false;
        force_split = 0;
        preserve_split = true;
        smart_split = false;
        smart_resizing = true;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        default_split_ratio = 1.0;
      };

      # MASTER LAYOUT
      master = {
        allow_small_split = false;
        special_scale_factor = 0.8;
        mfact = 0.55;
        new_on_top = false;
        orientation = "left";
      };

      # INPUT DEVICES
      # Layouts and Options you can find here:
      # https://github.com/Webconverger/webc/blob/master/usr/share/X11/xkb/rules/base.lst
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_space_toggle";
        repeat_rate = 75;
        repeat_delay = 250;
        follow_mouse = 1;
        mouse_refocus = true;
        float_switch_override_focus = 1;
        touchpad = {
          disable_while_typing = true;
          scroll_factor = 1.0;
          tap-to-click = true;
        };
      };

      # MISC SETTINGS
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 0;
        vfr = config.my.wm.performance;
        mouse_move_enables_dpms = false;
        key_press_enables_dpms = false;
        layers_hog_keyboard_focus = true;
        focus_on_activate = false;
        mouse_move_focuses_monitor = true;
        # Swallow exclusion does not work for some reason
        # I need to exclude chromium, usually if browser lauched from the terminal
        # it is for a) debug b) integration testing, both cases need browser to not be swallowed by terminal.
        # Disabled until not resolved: https://github.com/hyprwm/Hyprland/issues/2203
        enable_swallow = true;
        swallow_regex = "^(?i)${TERMINAL}$";
        swallow_exception_regex = "(?i)playwright.*";
        # Disable "Application not responding" dialog.
        enable_anr_dialog = false;
      };

      cursor = {
        hide_on_key_press = true;
        hide_on_touch = true;
        inactive_timeout = 3;
      };
    };
  };
}
