{
  lib,
  pkgs,
  ...
}:
let
  bctl = lib.getExe pkgs.brightnessctl;
in
{
  "format" = "{icon}";
  "tooltip-format" = "Brightness @ {percent}%";
  "on-scroll-up" = "${bctl} s 5%+";
  "on-scroll-down" = "${bctl} s 5%-";
  "on-click" = "${bctl} s 100%";
  "smooth-scrolling-threshold" = 1.0;
  "format-icons" = [
    "󱩎"
    "󱩏"
    "󱩐"
    "󱩑"
    "󱩒"
    "󱩓"
    "󱩔"
    "󱩕"
    "󱩖"
  ];
}
