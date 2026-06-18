-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
for i = 0, 9 do
	local key = tostring(i)
	hl.workspace_rule({ workspace = key, persistent = true })
end
