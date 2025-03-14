_:
let
  keyboard = "moergo-glove80-left-keyboard";
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
        # TODO: turn off keyboard backlight, this is host specific
        #{
        #  timeout = 150;
        #  on-timeout = "brightnessctl -s set 10 ";
        #  on-resume = "brightnessctl -r";
        #}
        # Switch layout to 0, should be english, and lock session after 7.5 min.
        {
          timeout = 450;
          on-timeout = "hyprctl switchxkblayout ${keyboard} 0 && loginctl lock-session";
        }
        # Turn off screen after 15min
        {
          timeout = 900;
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
