_:
# Requires youtrack-cli script defined in home/bin and installend in
# home/modules/packages/shellpkgs.nix
{
  exec = "youtrack-cli spent-today";
  tooltip = true;
  tooltip-format = "{text}";
  format = "";
  interval = 360;
  signal = 10;
  on-click = "pkill -SIGRTMIN+10 waybar";
}
