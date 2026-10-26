local function _or(list)
	return ("(%s)"):format(table.concat(list, "|"))
end

-- Bind apps to workspaces, by class.
local APP_WS = {
	[1] = { "^app.zen_browser.zen$" },
	[6] = { "^steam", "^com.usebottles.bottles$" },
	[10] = { "^Mattermost$" },
}
for ws_id, cls in ipairs(APP_WS) do
	hl.window_rule({ match = { initial_class = _or(cls) }, workspace = ws_id })
end
