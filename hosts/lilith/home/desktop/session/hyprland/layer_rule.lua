-- Layer Rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules
hl.layer_rule({
	name = "vicinae",
	blur = true,
	ignore_alpha = 0,
	match = { namespace = "vicinae" },
	no_anim = true,
})
hl.layer_rule({
	name = "waybar-blur",
	blur = true,
	ignore_alpha = 0,
	match = { namespace = "waybar" },
	no_anim = true,
})
hl.layer_rule({
	name = "wayle",
	animation = "slide bottom",
	blur = false,
	ignore_alpha = 0,
	match = { namespace = "^wayle-.*$" },
})
hl.layer_rule({
	name = "noctalia",
	match = { namespace = "noctalia-.*$" },
	ignore_alpha = 0.3,
	blur = true,
	blur_popups = true,
})
