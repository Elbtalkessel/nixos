-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
for i = 1, 10 do
	hl.workspace_rule({
		workspace = i,
		persistent = true,
		default_name = "—",
		layout_opts = {
			special_scale_factor = 0.95,
		},
	})
end

hl.workspace_rule({
	workspace = "special:magic",
	layout = "master",
})
