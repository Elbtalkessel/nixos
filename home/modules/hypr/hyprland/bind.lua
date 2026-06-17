-- Key Bindings
-- https://wiki.hypr.land/Configuring/Basics/Binds/

-- launch
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(M.launcher .. " toggle"))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(M.terminal))
hl.bind(" + XF86AudioRaiseVolume", hl.dsp.exec_cmd("set-volume 5%+"), { repeating = true })
hl.bind(" + XF86AudioLowerVolume", hl.dsp.exec_cmd("set-volume 5%-"), { repeating = true })
hl.bind(" + XF86MonBrightnessUp", hl.dsp.exec_cmd("set-brightness 20%+"), { repeating = true })
hl.bind(" + XF86MonBrightnessDown", hl.dsp.exec_cmd("set-brightness 20%-"), { repeating = true })

-- control
hl.bind("SUPER + f", hl.dsp.window.fullscreen())
hl.bind("SUPER + delete", hl.dsp.window.close())

-- move
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = key }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = key }))
end

-- resize
hl.bind("SUPER + CONTROL + H", hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + L", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + K", hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + J", hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true })

-- move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("ALT + TAB", hl.dsp.window.cycle_next())

-- special
hl.bind("SUPER + escape", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + escape", hl.dsp.window.move({ workspace = "special:magic" }))

-- focus
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- layouts
local layouts = { "scrolling", "dwindle", "master", "monocle" }
local function get_workspace()
	local workspace = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end
	return workspace
end

local function get_next_layout(workspace)
	local next_layout = "dwindle"
	for i = 1, #layouts do
		if layouts[i] == workspace.tiled_layout then
			local next_layout_idx = (i % #layouts) + 1
			next_layout = layouts[next_layout_idx]
			break
		end
	end
	return next_layout
end

local function notify_error(text)
	hl.notification.create({
		text = text,
		timeout = 5000,
		icon = M.ICON.QUESTION,
		color = M.COLOR.BG_ERROR_CONTAINER,
	})
end

local function notify_success(text)
	hl.notification.create({
		text = text,
		timeout = 5000,
		icon = M.ICON.SUCCESS,
		color = M.COLOR.BG_PRIMARY_CONTAINER,
	})
end

hl.bind("SUPER + ALT + TAB", function()
	local workspace = get_workspace()
	if not workspace then
		notify_error("Cannot determine layout")
		return
	end

	local next_layout = get_next_layout(workspace)
	if workspace.special then
		hl.workspace_rule({
			workspace = tostring(workspace.name),
			layout = next_layout,
		})
	else
		hl.workspace_rule({
			workspace = tostring(workspace.id),
			layout = next_layout,
		})
	end
	notify_success(string.format("Workspace switched to %s layout", next_layout))
end)

hl.bind("SUPER + ALT + N", function()
	local workspace = get_workspace()
	if not workspace then
		notify_error("Cannot determine layout")
		return
	end

	local next_layout = get_next_layout(workspace)
	hl.config({
		general = {
			layout = next_layout,
		},
	})
	notify_success(string.format("Switched to %s layout", next_layout))
end)
