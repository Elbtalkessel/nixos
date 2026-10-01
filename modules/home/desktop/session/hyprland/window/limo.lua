local function _or(list)
	return ("(%s)"):format(table.concat(list, "|"))
end

local SIZE_RG = { 1000, 600 }
local SIZE_SM = { 600, 300 }

hl.window_rule({
	match = {
		initial_class = "limo",
	},
	float = true,
})

hl.window_rule({
	match = { float = true, initial_title = "^Virtual Machine Manager$" },
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

-- Tile limo's main window (only Limo in title), order ^ matters.
hl.window_rule({
	match = {
		initial_title = "^Limo$",
	},
	float = false,
})
