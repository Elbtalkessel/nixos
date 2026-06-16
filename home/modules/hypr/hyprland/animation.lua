-- ANIMATIONS
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("quick", {
	type = "bezier",
	points = { { 0.05, 0.9 }, { 0.1, 1.05 } },
})
hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 1.0,
	bezier = "quick",
})
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 1.0,
	bezier = "quick",
	style = "popin 80%",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 2.0,
	bezier = "quick",
})
hl.animation({
	leaf = "borderangle",
	enabled = true,
	speed = 2.0,
	bezier = "quick",
})
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 1.0,
	bezier = "quick",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 1.0,
	bezier = "quick",
})
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 1.0,
	bezier = "quick",
	style = "slidevert",
})
hl.animation({
	leaf = "layers",
	enabled = true,
	speed = 1.0,
	bezier = "quick",
})
