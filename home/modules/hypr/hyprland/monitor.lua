-- MONITOR
-- https://wiki.hypr.land/Configuring/Basics/Monitors/#general

local MAIN = "eDP-1"
local EXTR = "HDMI-A-1"

hl.monitor({
	output = MAIN,
	position = "auto",
	mode = "highres",
	scale = 1,
	disabled = false,
})

hl.monitor({
	output = EXTR,
	position = "0x0",
	mode = "preffered",
	scale = 1,
	disabled = false,
})
