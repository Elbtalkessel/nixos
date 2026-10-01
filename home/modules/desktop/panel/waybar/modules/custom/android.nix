{ pkgs, ... }:
let
  script =
    pkgs.writeShellScript "waybar-android.sh" # bash
      ''
        if test "$1" == "is-plugged"; then
          adb get-state 1>/dev/null 2>/dev/null
        fi
        if test "$1" == "bat"; then
          adb shell cmd battery get level 2>/dev/null
        fi
      '';
in
{
  exec = "${script} bat";
  exec-if = "${script} is-plugged";
  interval = 360;
  signal = 11;
  on-click = "pkill -SIGRTMIN+11 waybar";
  tooltip = true;
  tooltip-format = "{text}%";
  format = "";
}
