-- "Smart gaps" / "No gaps when only"
-- https://wiki.hypr.land/configuring/code-snippets/#smart-gaps
-- https://wiki.hypr.land/configuring/selectors/#workspace-filters
-- w: workspace; s: special; t: tiled; v: visible; 1: maximized; f: floating;
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
	name = "no-gaps-wtv1",
	match = { float = false, workspace = "w[tv1]s[false]" },
	border_size = 0,
	rounding = 0,
})
hl.window_rule({
	name = "no-gaps-f1",
	match = { float = false, workspace = "f[1]s[false]" },
	border_size = 0,
	rounding = 0,
})
