local function _or(list)
	return ("(%s)"):format(table.concat(list, "|"))
end

-- https://github.com/winapps-org/winapps/issues/779
hl.window_rule({
	match = {
		initial_class = _or({
			"^winboat-.*",
			"^fmodel.exe$",
			"^stalker2_pakgui_v1-4.exe$",
		}),
	},
	suppress_event = "maximize",
	float = true,
})
hl.window_rule({
	match = {
		initial_class = _or({
			"^winboat-Wwise$",
		}),
	},
	suppress_event = "maximize",
	float = false,
})
