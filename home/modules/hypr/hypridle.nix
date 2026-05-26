{ lib, ... }:
let
  # Lock session.
  lock = true;
  # Turn off screen.
  screen-off = true;
  # Suspend.
  suspend = false;
in
{
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
        # Lower brightness after 5 minutes.
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
      ]
      ++ (lib.lists.optional lock {
        timeout = 450;
        on-timeout = "hyprswitch 0 && loginctl lock-session";
      })
      ++ (lib.lists.optional screen-off {
        timeout = 900;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
      })
      ++ (lib.lists.optional suspend {
        timeout = 3600;
        on-timeout = "systemctl suspend";
      });
    };
  };
}
