{ lib, lpad, ... }:
{
  "format" = "{icon}";
  "tooltip-format" = "{percent}%";
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
