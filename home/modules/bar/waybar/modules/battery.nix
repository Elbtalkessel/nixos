{
  lib,
  lpad,
  pkgs,
  ...
}:
let
  notify-send = lib.getExe pkgs.libnotify;
in
{
  "format" = "{icon}";
  "tooltip-format" = ''
    Left      {time}
    Capacity  {capacity}%
    Power     {power}W
    Charged   {cycles}×
    Health    {health}%'';
  "format-icons" = lib.map lpad [
    "󰁺"
    "󰁻"
    "󰁼"
    "󰁽"
    "󰁾"
    "󰁿"
    "󰂀"
    "󰂁"
    "󰂂"
    ""
  ];
  "states" = {
    "warning" = 30;
    "critical" = 15;
  };
  "events" = {
    "on-discharging-warning" = "${notify-send} -u normal 'Low Battery'";
    "on-discharging-critical" = "${notify-send} -u critical 'Very Low Battery'";
    "on-charging-100" = "${notify-send} -u normal 'Battery Full!'";
  };
}
