{
  lib,
  lpad,
  pkgs,
  ...
}:
let
  bctl = lib.getExe pkgs.brightnessctl;
in
{
  "format" = "{icon}";
  "tooltip-format" = "{percent}%";
  "on-scroll-up" = "${bctl} s 2%+";
  "on-scroll-down" = "${bctl} s 2%-";
  "on-click" = "${bctl} s 100%";
  "format-icons" = lib.map lpad [
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
