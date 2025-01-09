_:
let
  WALLPAPER = "/media/pictures/krjef9fchcx61.jpg";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      monitor = ",highres,auto,1";
      xwayland = {
        force_zero_scaling = true;
      };

      # While v2 rules allow multiple rules to be applied, the `center` rule
      # or `move` rule is not available.
      # https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrule = [
        "float,^(org.gnome.Calculator)$"
        "center,^(org.gnome.Calculator)$"

        "float,^(jetbrains-toolbox)$"
        "center,^(jetbrains-toolbox)$"

        "float,^(udiskie)$"
        "center,^(udiskie)$"

        "float,^(polkit-gnome-authentication-agent-1)$"
        "center,^(polkit-gnome-authentication-agent-1)$"

        # Force focus on browser file pick dialog
        "center,title:^(Open File)$"
        "float,title:^(Open File)$"
        "stayfocused,title:^(Open File)$"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$M" = "SUPER";
      "$TERMINAL" = "alacritty";

      "exec-once" = [
        "waybar"
        "hyprpaper"
      ];

      # KEY BINDINGS, see https://wiki.hyprland.org/Configuring/Binds/ for more
      # Two hand layout, left is holding modifier, right is presssing a key# Two hand layout, left is holding modifier, right is presssing a key

      # Special
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl -c backlight s +20"
        ", XF86MonBrightnessDown, exec, brightnessctl -c backlight s 20-"
        "$M CONTROL, H, resizeactive, -25 0"
        "$M CONTROL, L, resizeactive, 25 0"
        "$M CONTROL, K, resizeactive, 0 -25"
        "$M CONTROL, J, resizeactive, 0 25"
      ];
      # MOVE/RESIZE WINDOWS with M + LMB/RMB and dragging
      bindm = [
        "$M, mouse:272, movewindow"
        "$M, mouse:273, resizewindow"
      ];
      bind = [
        ", XF86Calculator, exec, gnome-calculator"
        "$M, left, exec, hyprctl switchxkblayout moergo-glove80-left-keyboard next"

        # Launcher
        "$M, Space, exec, tofi-drun | xargs hyprctl dispatch exec --"
        "$M, right, exec, tofi-run | xargs hyprctl dispatch exec --"
        "$M Shift, Space, exec, repl $TERMINAL"
        "$M, p, exec, gopass ls --flat | tofi | xargs --no-run-if-empty gopass show -c"
        "$M, Return, exec, $TERMINAL"

        # Window management
        "$M, f, fullscreen,"
        "$M, delete, killactive,"
        "$M, backspace, exec, hyprctl --batch 'dispatch togglefloating active; dispatch pin active'"
        "$M SHIFT, escape, movetoworkspace, special" # move to the special workspace
        "$M, escape, togglespecialworkspace" # show/hide special workspace

        # MOVE FOCUS with M + arrow keys
        "$M, H, movefocus, l"
        "$M, L, movefocus, r"
        "$M, K, movefocus, u"
        "$M, J, movefocus, d"

        # MOVE WINDOW with M SHIFT + arrow keys
        "$M SHIFT, H, movewindow, l"
        "$M SHIFT, L, movewindow, r"
        "$M SHIFT, K, movewindow, u"
        "$M SHIFT, J, movewindow, d"

        # SWITCH WORKSPACES with M + [0-9]
        "$M, 1, workspace, 1"
        "$M, 2, workspace, 2"
        "$M, 3, workspace, 3"
        "$M, 4, workspace, 4"
        "$M, 5, workspace, 5"
        "$M, 6, workspace, 6"
        "$M, 7, workspace, 7"
        "$M, 8, workspace, 8"
        "$M, 9, workspace, 9"
        "$M, 0, workspace, 10"

        # MOVE ACTIVE WINDOW TO A WORKSPACE with M + SHIFT + [0-9]
        "$M SHIFT, 1, movetoworkspace, 1"
        "$M SHIFT, 2, movetoworkspace, 2"
        "$M SHIFT, 3, movetoworkspace, 3"
        "$M SHIFT, 4, movetoworkspace, 4"
        "$M SHIFT, 5, movetoworkspace, 5"
        "$M SHIFT, 6, movetoworkspace, 6"
        "$M SHIFT, 7, movetoworkspace, 7"
        "$M SHIFT, 8, movetoworkspace, 8"
        "$M SHIFT, 9, movetoworkspace, 9"
        "$M SHIFT, 0, movetoworkspace, 10"
        "$M, TAB, workspace, previous"
        "$M, F6, exec, screen shot"
        "$M, F7, exec, screen record"
      ];

      binds = {
        allow_workspace_cycles = true;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 0;
        blur = {
          enabled = false;
          size = 3;
          passes = 1;
          new_optimizations = true;
        };
      };

      layerrule = [
        # apply blur on notification layer such as mako or dunst
        "blur,notifications"
        "blur,waybar"
        # skip the blur on completely transparent parts (such as mako's margin)
        "ignorezero,notifications"
      ];

      animations = {
        enabled = true;
        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 2, myBezier"
          "windowsOut, 1, 2, default, popin 80%"
          "border, 1, 3, default"
          "borderangle, 1, 4, default"
          "fade, 1, 2, default"
          "workspaces, 1, 2, default"
        ];
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = false;
      };

      # GENERAL SETTINGS
      general = {
        border_size = 1;
        no_border_on_floating = false;
        gaps_in = 3;
        gaps_out = 3;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
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
        inherit_fullscreen = true;
        always_center_master = false;
      };

      # INPUT DEVICES
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
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
        vfr = false;
        mouse_move_enables_dpms = false;
        key_press_enables_dpms = false;
        layers_hog_keyboard_focus = true;
        focus_on_activate = false;
        mouse_move_focuses_monitor = true;
        enable_swallow = true;
        swallow_regex = "^(Alacritty)$";
      };

      cursor = {
        hide_on_key_press = true;
        hide_on_touch = true;
        inactive_timeout = 3;
      };
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "${WALLPAPER}"
      ];

      wallpaper = [
        ",${WALLPAPER}"
      ];
    };
  };
}
