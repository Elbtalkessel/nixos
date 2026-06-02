_: {
  xdg.configFile."hypr/hyprland/config.lua".text = # lua
    ''
      -- VARIABLES
      -- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
      hl.config({
      	-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
      	general = {
      		border_size = 0,
      		col = {
      			active_border = "rgba(403266ee) rgba(D8D2E6ee) 45deg",
      			inactive_border = "rgba(323233aa)",
      		},
      		extend_border_grab_area = true,
      		gaps_in = 2.500000,
      		gaps_out = 0,
      		hover_icon_on_border = true,
      		layout = "dwindle",
      	},
      	-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
      	decoration = {
      		blur = {
      			enabled = true,
      			new_optimizations = true,
      			passes = 2,
      			size = 10,
      		},
      		dim_inactive = true,
      		dim_strength = 0.200000,
      		rounding = 5,
      	},
      	-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
      	input = {
      		float_switch_override_focus = 0,
      		follow_mouse = 1,
      		follow_mouse_threshold = 10,
      		kb_layout = "us,ua",
      		kb_options = "grp:alt_space_toggle",
      		mouse_refocus = false,
      		repeat_delay = 250,
      		repeat_rate = 75,
      		touchpad = {
      			disable_while_typing = true,
      			scroll_factor = 1.000000,
      		},
      	},
      	-- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
      	misc = {
      		disable_hyprland_logo = true,
      		disable_splash_rendering = true,
      		enable_anr_dialog = false,
      		enable_swallow = true,
      		focus_on_activate = true,
      		key_press_enables_dpms = false,
      		layers_hog_keyboard_focus = true,
      		mouse_move_enables_dpms = false,
      		mouse_move_focuses_monitor = true,
      		swallow_exception_regex = "(?i)playwright.*",
      		swallow_regex = string.format("^(?i)%s$", TERM),
      		vfr = false,
      		vrr = 0,
      	},
      	-- https://wiki.hypr.land/Configuring/Basics/Variables/#binds
      	binds = {
      		allow_workspace_cycles = true,
      	},
      	-- https://wiki.hypr.land/Configuring/Basics/Variables/#xwayland
      	xwayland = {
      		enabled = true,
      		force_zero_scaling = true,
      	},
      	-- https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
      	cursor = {
      		hide_on_key_press = true,
      		hide_on_touch = true,
      		inactive_timeout = 3,
      	},
      	-- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/#config
      	dwindle = {
      		default_split_ratio = 1.000000,
      		force_split = 0,
      		preserve_split = true,
      		pseudotile = false,
      		smart_resizing = true,
      		smart_split = false,
      		special_scale_factor = 0.800000,
      		split_width_multiplier = 1.000000,
      		use_active_for_splits = true,
      	},
      	master = {
      		allow_small_split = false,
      		mfact = 0.550000,
      		new_on_top = false,
      		orientation = "left",
      		special_scale_factor = 0.800000,
      	},
      	-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
      	animations = {
      		enabled = true,
      	},
      })
    '';
}
