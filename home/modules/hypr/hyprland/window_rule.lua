local function _or(list)
	return ("(%s)"):format(table.concat(list, "|"))
end

-- Window Rule
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({
	match = {
		initial_class = _or({
			"org.gnome.Calculator",
			"udiskie",
			"polkit-gnome-authentication-agent-1",
			"solaar",
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
})
hl.window_rule({ match = { initial_title = "(Picture-in-Picture)" }, float = true })
hl.window_rule({ match = { initial_class = _or({ "zenity" }) }, float = true })
hl.window_rule({ match = { modal = true }, center = true, float = true, stay_focused = true })
hl.window_rule({ match = { float = true }, no_blur = true })
hl.window_rule({ match = { initial_class = "^jetbrains-toolbox$" }, stay_focused = true })
hl.window_rule({
	match = { float = true, initial_class = "jetbrains-pycharm", initial_title = "^$" },
	min_size = "1000 600",
	no_anim = true,
	border_size = 0,
	no_shadow = true,
})
hl.window_rule({ match = { initial_class = "Removing Cookies and Site Data" }, min_size = "579 234" })
hl.window_rule({ match = { initial_class = "^app.zen_browser.zen$" }, workspace = 1 })
hl.window_rule({ match = { initial_class = "^jetbrains-pycharm$" }, workspace = 2 })
hl.window_rule({ match = { initial_class = "^steam$" }, workspace = 6 })
hl.window_rule({ match = { initial_class = "^com.usebottles.bottles$" }, workspace = 6 })
hl.window_rule({ match = { initial_class = "^Mattermost$" }, workspace = 10 })

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
