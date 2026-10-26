local function _or(list)
	return ("(%s)"):format(table.concat(list, "|"))
end

local SIZE_RG = { 1000, 600 }
local SIZE_XS = { 500, 200 }

-- Window Rule
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- The are prompts that should not be ignored (or open in first place.)
hl.window_rule({
	match = {
		initial_class = _or({
			"udiskie",
			"xdg-desktop-portal-gtk",
		}),
	},
	center = true,
	float = true,
	stay_focused = true,
})

hl.window_rule({
	match = {
		initial_title = _or({
			"Open File",
			"Open Files",
			"Set Background",
		}),
	},
	center = true,
	float = true,
	stay_focused = true,
	size = SIZE_RG,
})

-- These do make more sense when floating.
hl.window_rule({
	match = {
		initial_title = "(Picture-in-Picture)",
	},
	float = true,
})

hl.window_rule({
	match = {
		initial_class = _or({
			"^org\\.gnome\\.Calculator$",
			"zenity",
			"org\\.pulseaudio\\.pavucontrol",
			"yad",
			"^org.gnome.seahorse.Application$",
			"^solaar$",
		}),
	},
	float = true,
})

hl.window_rule({
	match = { float = true, initial_class = "^org\\.pulseaudio\\.pavucontrol$" },
	size = SIZE_RG,
})

-- Electron apps render popups as a floating window, the popup gets ugly blurry ring.
hl.window_rule({
	match = {
		float = true,
	},
	no_blur = true,
})

-- This floating prompt sometimes rendered too small.
hl.window_rule({
	match = {
		initial_class = "Removing Cookies and Site Data",
	},
	size = SIZE_XS,
})
