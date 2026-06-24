local function _or(list)
	return ("(%s)"):format(table.concat(list, "|"))
end

local SIZE_RG = { 1000, 600 }
local SIZE_SM = { 600, 300 }
local SIZE_XS = { 500, 200 }

-- Window Rule
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- The are prompts that should not be ignored (or open in first place.)
hl.window_rule({
	match = {
		initial_class = _or({
			"udiskie",
			"polkit-gnome-authentication-agent-1",
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
			-- Float limo popup windows (limo in class)
			"limo",
			"org\\.pulseaudio\\.pavucontrol",
			"yad",
			"^\\.virt-manager-wrapped$",
		}),
	},
	float = true,
})

-- Floating window overrides to make the tiled instead,
-- sometimes it hard to make a better rule.
hl.window_rule({
	match = {
		initial_title = _or({
			-- Tile limo's main window (only Limo in title), order ^ matters.
			"^Limo$",
			-- the main virt machine manager should float,
			-- but guest should not `<name of the vm> on on QEMU/KVM`.
			"^.* on QEMU/KVM$",
		}),
	},
	float = false,
})

-- Electron apps render popups as a floating window, the popup gets ugly blurry ring.
hl.window_rule({
	match = {
		float = true,
	},
	no_blur = true,
})

-- Launching an app from the toolbox will switch focus to the app,
-- usually I want to launch and close the toolbox right away.
hl.window_rule({ match = { initial_class = "^jetbrains-toolbox$" }, stay_focused = true })

-- Various PyCharm floating window (almost all of them, search, find and replace, etc.) are
-- rendered too small, animation makes border stay while window content is collapsed. Removed border
-- for good measure too.

hl.window_rule({
	match = { float = true, initial_class = "jetbrains-pycharm", initial_title = "^$" },
	min_size = "1000 600",
	no_anim = true,
	border_size = 0,
	no_shadow = true,
})

hl.window_rule({
	match = { float = true, initial_title = "^Virtual Machine Manager$" },
	size = SIZE_RG,
})

hl.window_rule({
	match = { float = true, initial_class = "^org\\.pulseaudio\\.pavucontrol$" },
	size = SIZE_RG,
})

hl.window_rule({
	match = {
		float = true,
		initial_class = "^limo$",
		initial_title = _or({
			"^Settings$",
			"^New .*$",
			"^Add .*$",
			"^Edit .*$",
		}),
	},
	size = SIZE_RG,
})

hl.window_rule({
	match = {
		float = true,
		initial_class = "^limo$",
		-- there is also `Edit .*`, but overlaps with Edit <tool name>,
		-- we need a bigger window for that.
		initial_title = _or({
			"^Confirm .*$",
			"^New Profile$",
		}),
	},
	size = SIZE_SM,
})

-- This floating prompt sometimes rendered too small.
hl.window_rule({
	match = {
		initial_class = "Removing Cookies and Site Data",
	},
	size = SIZE_XS,
})

-- Bind apps to workspaces, by class.
local APP_WS = {
	[1] = { "^app.zen_browser.zen$" },
	[2] = { "^jetbrains-pycharm$" },
	[6] = { "^steam", "^com.usebottles.bottles$" },
	[10] = { "^Mattermost$" },
}
for ws_id, cls in ipairs(APP_WS) do
	hl.window_rule({ match = { initial_class = _or(cls) }, workspace = ws_id })
end

-- "Smart gaps" / "No gaps when only"
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
	name = "no-gaps-wtv1",
	match = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})
hl.window_rule({
	name = "no-gaps-f1",
	match = { float = false, workspace = "f[1]" },
	border_size = 0,
	rounding = 0,
})
