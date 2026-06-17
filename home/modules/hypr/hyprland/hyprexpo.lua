-- https://hyprexpo.lol/docs/configuration/options

local function toRGB(color)
	local hex = color:gsub("#", "")
	local func = (#hex == 8) and "rgba" or "rgb"
	return string.format("%s(%s)", func, hex)
end

hl.config({
	plugin = {
		hyprexpo = {
			columns = 3,
			max_workspace = 9,
			show_cursor = 0,
			bg_col = toRGB(M.COLOR.BG_SURFACE),
			border_color_focus = toRGB(M.COLOR.BG_PRIMARY_CONTAINER),
			drag_drop_proxy_color = toRGB(M.COLOR.BG_PRIMARY_CONTAINER .. "42"),
			drag_drop_proxy_active_color = toRGB(M.COLOR.BG_SECONDARY_CONTAINER .. "42"),
			border_width = 1,
			border_color_current = "",
			border_color_hover = "",
			tile_rounding = 4,
		},
	},
})

hl.bind("SUPER + G", function()
	hl.plugin.hyprexpo.expo("on")
	hl.dsp.submap("hyprexpo")
end)

hl.define_submap("hyprexpo", function()
	hl.bind("h", function()
		hl.plugin.hyprexpo.kb_focus("left")
	end)
	hl.bind("l", function()
		hl.plugin.hyprexpo.kb_focus("right")
	end)
	hl.bind("k", function()
		hl.plugin.hyprexpo.kb_focus("up")
	end)
	hl.bind("j", function()
		hl.plugin.hyprexpo.kb_focus("down")
	end)
	hl.bind("return", function()
		hl.plugin.hyprexpo.kb_confirm()
		hl.dsp.submap("reset")
	end)
	hl.bind("escape", function()
		hl.plugin.hyprexpo.expo("off")
		hl.dsp.submap("reset")
	end)
	hl.bind("SUPER + G", function()
		hl.plugin.hyprexpo.expo("off")
		hl.dsp.submap("reset")
	end)
end)
