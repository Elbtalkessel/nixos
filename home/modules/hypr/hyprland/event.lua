-- Events
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Expanding-functionality/#events
hl.on("hyprland.start", function()
	hl.exec_cmd("solaar --window=hide --battery-icons=symbolic")
	hl.exec_cmd("noctalia -d")
	hl.exec_cmd("systemctl --user start hyprland-session.service")
end)
