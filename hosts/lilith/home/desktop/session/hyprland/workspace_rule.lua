-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
for i = 1, 10 do
	hl.workspace_rule({
		workspace = i,
		persistent = true,
		default_name = "—",
	})
end

hl.workspace_rule({
	workspace = "special:magic",
	on_created_empty = "foot",
	layout = "master",
})
