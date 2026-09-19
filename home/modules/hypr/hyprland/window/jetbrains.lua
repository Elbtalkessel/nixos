-- Launching an app from the toolbox will switch focus to the app,
-- usually I want to launch and close the toolbox right away.
hl.window_rule({
	match = { initial_class = "^jetbrains-toolbox$" },
	-- Force tile window, otherwise it floats and renders off-screen.
	no_max_size = true,
	float = false,
})

-- Various PyCharm floating window (almost all of them, search, find and replace, etc.) are
-- rendered too small, animation makes border stay while window content is collapsed. Removed border
-- for good measure too.

hl.window_rule({
	match = { float = true, initial_class = "jetbrains-pycharm", initial_title = "^$" },
	no_anim = true,
	border_size = 0,
	no_shadow = true,
})
