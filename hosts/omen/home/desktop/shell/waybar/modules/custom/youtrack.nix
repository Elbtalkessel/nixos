_:
# Requires the youtrack-cli script defined in
# modules/home/core/tools/scripts/default.nix
{
  exec = "youtrack-cli spent-today";
  tooltip = true;
  tooltip-format = "{text}";
  format = "";
  interval = 360;
  signal = 10;
  on-click = "pkill -SIGRTMIN+10 waybar";
}
