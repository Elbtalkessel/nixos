-- Events
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Expanding-functionality/#events
hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm-app solaar --window=hide --battery-icons=symbolic")
	hl.exec_cmd("systemctl --user start hyprland-session.service")
	hl.exec_cmd("uwsm-app -- noctalia -d")
end)

local ICONS = {
	{ { "ghostty" }, "" },
	{ { "zen" }, "󰈹" },
	{ { "pycharm" }, "" },
	{ { "mattermost" }, "󰭹" },
	{ { "steam" }, "" },
	{ { "nautilus" }, "" },
	{ { "telegram.desktop" }, "" },
}

--@param cls string|nil
--@return string|nil
local function find_icon(cls)
	if not cls then
		return nil
	end

	cls = cls:lower()
	for _, entry in ipairs(ICONS) do
		for _, suffix in ipairs(entry[1]) do
			if cls:sub(-#suffix) == suffix then
				return entry[2]
			end
		end
	end

	return nil
end

local function debug(msg)
	hl.notification.create({
		text = msg,
		timeout = 5000,
	})
end

local function set_icon(window, workspace)
	if window == nil then
		debug(("No window, new name is %s."):format(workspace.id))
		hl.dispatch(hl.dsp.workspace.rename({
			workspace = workspace.id,
			name = tostring(workspace.id),
		}))
	end
	local icon = find_icon(window.class)
	if icon == nil then
		debug(("No icon for class %s, doing nothing."):format(window.class))
		return
	end
	debug(("Setting icon %s on workspace %s"):format(icon, workspace.id))
	hl.dispatch(hl.dsp.workspace.rename({
		workspace = workspace.id,
		name = icon,
	}))
end

hl.on("window.open", function(window)
	local workspace = window.workspace
	if not workspace then
		return
	end
	set_icon(window, workspace)
end)

hl.on("window.close", function(window)
	local workspace = window.workspace
	if not workspace then
		return
	end
	-- workspace.last_window likely points to window we just closed, unreliable.
	local windows = hl.get_workspace_windows(workspace.id)
	set_icon(windows[1], workspace)
end)
