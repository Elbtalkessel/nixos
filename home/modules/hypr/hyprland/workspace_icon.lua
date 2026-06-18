-- Workspace icon manager (event-driven + derived state)

-- A poor man's workspace icons derived from open window.
-- An icon from the ICONS table assigned to a workspace each time a
-- window open and stored in the state table as a stack, {[1] = {"", ""}}.
-- When a window closes, icon is poped from the stack and previous assigned to the workspace.

-- Why not query hyprland for open windows on a workspace: available functions, such as `get_workspace_windows` isn't
-- reliable on `window.close` event, likely I get pointer to a window that about to close, didn't debug it further tho,
-- tracking state seems and robust.
-- I did try `window.destroy`, however closing ghostty or nautilus didn't call the handler,
-- I guess window stays somewhere to quickly reopen.

-- Why not reuse icons specified in desktop file:
-- - I'm not sure if lua has access to filesystem.
-- - I'm not sure if hyprland can use PNGs as desktop name, I don't think so.

-- Improvements:
-- - More icons.
-- - Rewrite the ICONS table, I think I don't need multiple names for a single icon.

local ICONS = {
	ghostty = "",
	zen = "󰈹",
	pycharm = "",
	mattermost = "󰭹",
	steam = "",
	nautilus = "",
	["telegram.desktop"] = "",
	["noctalia.settings"] = "󰏒",
	["jetbrains-toolbox"] = "",
	bottles = "󰡔",
	["virt-manager-wrapped"] = "",
	qutebrowser = "",
	localsend_app = "󰌘",
}

-- window_address -> { workspace = id, icon = string|nil }
local windows = {}

-- workspace_id -> last applied name (avoid spam)
local last_workspace_name = {}

------------------------------------------------------------
-- ICON RESOLUTION
------------------------------------------------------------

--@param cls string|nil
local function normalize_class(cls)
	if not cls then
		return nil
	end
	return cls:lower():gsub("%s+", "")
end

--@param cls string|nil
local function find_icon(cls)
	cls = normalize_class(cls)
	if not cls then
		return nil
	end

	-- exact match first
	if ICONS[cls] then
		return ICONS[cls]
	end

	-- suffix match fallback
	for k, icon in pairs(ICONS) do
		if cls:sub(-#k) == k then
			return icon
		end
	end

	return nil
end

------------------------------------------------------------
-- WORKSPACE DERIVATION
------------------------------------------------------------

--@param workspace_id number
local function workspace_best_icon(workspace_id)
	local last_icon = nil

	for _, win in pairs(windows) do
		if win.workspace == workspace_id and win.icon then
			last_icon = win.icon
		end
	end

	return last_icon
end

--@param workspace_id number
local function apply_workspace_name(workspace_id)
	local icon = workspace_best_icon(workspace_id)
	local name = icon or tostring(workspace_id)

	if last_workspace_name[workspace_id] == name then
		return
	end
	last_workspace_name[workspace_id] = name

	hl.dispatch(hl.dsp.workspace.rename({
		workspace = workspace_id,
		name = name,
	}))
end

------------------------------------------------------------
-- EVENT HANDLERS
------------------------------------------------------------

hl.on("window.open", function(window)
	if not window or not window.address then
		return
	end
	if not window.workspace then
		return
	end

	local ws = window.workspace.id
	local icon = find_icon(window.class)

	windows[window.address] = {
		workspace = ws,
		icon = icon,
	}

	apply_workspace_name(ws)
end)

hl.on("window.close", function(window)
	if not window or not window.address then
		return
	end

	local entry = windows[window.address]
	if not entry then
		return
	end

	local ws = entry.workspace
	windows[window.address] = nil

	apply_workspace_name(ws)
end)
