_:
# Requires youtrack-cli script defined in home/bin and installend in
# home/modules/packages/shellpkgs.nix
{
  exec = "youtrack-cli spent-today 2>/dev/null || echo ";
  tooltip = true;
  tooltip-format = "Time spent today. Click to refresh.";
  interval = 360;
  signal = 10;
  on-click = "pkill -SIGRTMIN+10 waybar";
}
