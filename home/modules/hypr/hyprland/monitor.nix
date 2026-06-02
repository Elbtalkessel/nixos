_: {
  xdg.configFile."hypr/hyprland/monitor.lua".text = # lua
    ''
      -- MONITOR
      -- https://wiki.hypr.land/Configuring/Basics/Monitors/#general
      hl.monitor({
      	output = "eDP-1",
      	position = "auto",
      	mode = "highres",
      	scale = 1,
      })
    '';
}
