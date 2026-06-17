-- https://hyprexpo.lol/docs/configuration/options

hl.config({
	plugin = {
		hyprexpo = {
			columns = 3,
		},
	},
})

hl.bind("SUPER + G", function()
	hl.plugin.hyprexpo.expo("on")
	hl.dsp.submap("hyprexpo")
end)

hl.define_submap("hyprexpo", function()
	hl.bind("h", function()
		hl.plugin.hyprexpo.kb_focus("left")
	end)
	hl.bind("l", function()
		hl.plugin.hyprexpo.kb_focus("right")
	end)
	hl.bind("k", function()
		hl.plugin.hyprexpo.kb_focus("up")
	end)
	hl.bind("j", function()
		hl.plugin.hyprexpo.kb_focus("down")
	end)
	hl.bind("return", function()
		hl.plugin.hyprexpo.kb_confirm()
		hl.dsp.submap("reset")
	end)
	hl.bind("escape", function()
		hl.plugin.hyprexpo.expo("off")
		hl.dsp.submap("reset")
	end)
	hl.bind("SUPER + G", function()
		hl.plugin.hyprexpo.expo("off")
		hl.dsp.submap("reset")
	end)
end)
