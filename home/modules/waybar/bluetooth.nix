{ lib, lpad }:
{
  format = "{icon}";
  format-disabled = "";
  format-off = lpad "󰂲";
  format-on = "";
  format-connected = lpad "󰂴";
  format-icons = lib.map lpad [
    "󰤾"
    "󰤿"
    "󰥀"
    "󰥁"
    "󰥂"
    "󰥃"
    "󰥄"
    "󰥅"
    "󰥆"
    "󰥈"
  ];
  tooltip-format = "{controller_alias}\t{controller_address}";
  tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
  tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
  on-click = "blueman-manager";
}
