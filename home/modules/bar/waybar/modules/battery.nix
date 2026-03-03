{ lib, lpad, ... }:
{
  "format" = "{icon}";
  "tooltip-format" = "{capacity}%";
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
}
