-- MONITOR
-- https://wiki.hypr.land/Configuring/Basics/Monitors/#general

local MAIN = "eDP-1"
local EXTR = "HDMI-A-1"

hl.monitor({
	output = MAIN,
	position = "auto",
	mode = "highres",
	scale = 1.25,
	disabled = false,
})

hl.monitor({
	output = EXTR,
	position = "auto",
	mode = "2560x1080@74.99Hz",
	scale = 1,
	disabled = false,
})
