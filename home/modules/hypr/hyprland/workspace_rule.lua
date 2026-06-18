-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
for i = 1, 10 do
	local key = tostring(i % 10)
	hl.workspace_rule({ workspace = key, persistent = true })
end
