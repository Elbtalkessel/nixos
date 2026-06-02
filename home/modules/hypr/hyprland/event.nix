_: {
  xdg.configFile."hypr/hyprland/event.lua".text = # lua
    ''
      -- Events
      -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Expanding-functionality/#events
      hl.on("hyprland.start", function()
      	hl.dsp.exec_cmd("solaar --window=hide --battery-icons=symbolic")
      	hl.dsp.exec_cmd("systemctl --user start hyprland-session.service")
      end)
    '';
}
