-- Events
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Expanding-functionality/#events
hl.on("hyprland.start", function()
	hl.exec_cmd("solaar --window=hide --battery-icons=symbolic")
	hl.exec_cmd("noctalia -d")
	hl.exec_cmd("systemctl --user start hyprland-session.service")
end)
-- Move everything to a newly added monitor.
-- Vibecoded, to complex for such simple task.
local opts = {
    -- Only migrate when one of these monitors appears, e.g. { "DP-1", "HDMI-A-1" }.
    -- Empty table = any newly plugged monitor.
    targets = {},
    -- Workspaces to leave alone (exact names, e.g. "3", "name:music").
    -- Anything named "special:*" is always left alone.
    pinned = {},
    -- Show a notification with the number of workspaces moved.
    notify = true,
}
-- The workspace object's monitor field is not documented in detail on the wiki,
-- so accept either a Monitor object or a plain name.
local function monitor_name(ws)
    local m = ws.monitor
    if type(m) == "table" then
        return m.name
    end
    return m
end

local function is_pinned(name)
    if not name then
        return true
    end
    if name:match("^special:") then
        return true
    end
    for _, p in ipairs(opts.pinned) do
        if p == name then
            return true
        end
    end
    return false
end

local function wanted(name)
    if #opts.targets == 0 then
        return true
    end
    for _, t in ipairs(opts.targets) do
        if t == name then
            return true
        end
    end
    return false
end

local function migrate(dest)
    local dest_name = type(dest) == "table" and dest.name or dest
    if not dest_name or not wanted(dest_name) then
        return
    end
    for _, ws in ipairs(hl.get_workspaces()) do
        if monitor_name(ws) ~= dest_name and not is_pinned(ws.name) then
            hl.dispatch(hl.dsp.workspace.move({
                workspace = ws.name,
                monitor = dest_name,
            }))
        end
    end
end

hl.on("monitor.added", function(monitor)
    migrate(monitor)
    hl.dsp.focus({ workspace = "1" })
end)
