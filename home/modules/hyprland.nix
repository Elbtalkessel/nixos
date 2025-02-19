{ pkgs, lib, ... }:
let
  center-rule = clss: [
    "float,^(${builtins.concatStringsSep "|" clss})$"
    "center,^(${builtins.concatStringsSep "|" clss})$"
  ];
in
{
  # Hypr* (land, paper, etc)
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
      windowrule = center-rule [
        "org.gnome.Calculator"
        "jetbrains-toolbox"
        "udiskie"
        "polkit-gnome-authentication-agent-1"
        "solaar"
      ];
      windowrulev2 = [
        # All jetbrains window has the same class,
        # no way distinguish between a type completion window and search
        # widnow.
        # "center stayfocused,floating:1"
        #"fullscreen,class:^(jetbrains-pycharm)$,floating:1"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$M" = "SUPER";
      "$TERMINAL" = "alacritty";

      "exec-once" = [
        "waybar"
        "hyprpaper"
        "${pkgs.solaar}/bin/solaar --window=hide --battery-icons=symbolic"
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
        "$M, left, exec, hyprctl switchxkblayout moergo-glove80-left-keyboard next"

        # Launcher
        "$M, Space, exec, tofi-drun | xargs hyprctl dispatch exec --"
        "$M SHIFT, Space, exec, tofi-run | xargs hyprctl dispatch exec --"
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
        rounding = 5;
        blur = {
          # Buggy, creates blurred ring around popover menus.
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
        # Swallow exclusion does not work for some reason
        # I need to exclude chromium, usually if browser lauched from the terminal
        # it is for a) debug b) integration testing, both cases need browser to not be swallowed by terminal.
        # Disabled until not resolved: https://github.com/hyprwm/Hyprland/issues/2203
        enable_swallow = false;
        swallow_regex = "^(Alacritty)$";
        swallow_exception_regex = "(?i).*chromium|playwright.*";
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
        "${../../assets/bg.jpg}"
      ];

      wallpaper = [
        ",${../../assets/bg.jpg}"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        grace = 30;
        hide_cursor = true;
        no_fade_in = false;
        ignore_empty_input = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      label = [
        # Day
        {
          text = ''cmd[update:1000] echo -e "$(date +"%A")"'';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 90;
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        # Date-Month
        {
          text = ''cmd[update:1000] echo -e "$(date +"%d %B")"'';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 40;
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          text = ''cmd[update:1000] echo "<span>$(date +"- %I:%M -")</span>"'';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 20;
          position = "0, 190";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          text = "$USER";
          color = "rgba(216, 222, 233, 0.80)";
          font_size = 18;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      # Profie-Photo
      image = {
        path = "${../../assets/profpic.jpg}";
        border_size = 2;
        border_color = "rgba(255, 255, 255, .65)";
        size = 130;
        rounding = -1;
        rotate = 0;
        reload_time = -1;
        position = "0, 40";
        halign = "center";
        valign = "center";
      };

      input-field = [
        {
          size = "300, 60";
          outline_thickness = 2;
          # Scale of input-field height, 0.2 - 0.8
          dots_size = 0.2;
          # Scale of dots' absolute size, 0.0 - 1.0
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(255, 255, 255, 0)";
          inner_color = "rgba(255, 255, 255, 0.1)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##ffffff99">Enter Password</span>'';
          hide_input = false;
          position = "0, -210";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # https://mynixos.com/home-manager/options/services.hypridle
  services.hypridle = {
    enable = true;
    # https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        # Lower brightness after 2.5 minutes.
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        # TODO: turn off keyboard backlight, this is host specific
        #{
        #  timeout = 150;
        #  on-timeout = "brightnessctl -s set 10 ";
        #  on-resume = "brightnessctl -r";
        #}
        # Lock session after 5 min.
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # Turn off screen after 5.5min
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # Suspend after 30 min.
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
