_: {
  xdg.configFile."hypr/hyprland/bind.lua".text = # lua
    ''
      -- Key Bindings
      -- https://wiki.hypr.land/Configuring/Basics/Binds/
      hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("vicinae toggle"))
      hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("ghostty"))
      hl.bind(" + XF86AudioRaiseVolume", hl.dsp.exec_cmd("set-volume 5%+"), { repeating = true })
      hl.bind(" + XF86AudioLowerVolume", hl.dsp.exec_cmd("set-volume 5%-"), { repeating = true })
      hl.bind(" + XF86MonBrightnessUp", hl.dsp.exec_cmd("set-brightness 20%+"), { repeating = true })
      hl.bind(" + XF86MonBrightnessDown", hl.dsp.exec_cmd("set-brightness 20%-"), { repeating = true })

      hl.bind("SUPER + f", hl.dsp.window.fullscreen())
      hl.bind("SUPER + delete", hl.dsp.window.close())
      hl.bind("SUPER + backspace", function()
      	hl.dsp.window.float({ action = "toggle" })
      	hl.dsp.window.pin({ window = "activewindow" })
      end)
      hl.bind("SUPER SHIFT + escape", hl.dsp.window.move({ workspace = "special" }))
      hl.bind("SUPER SHIFT + H", hl.dsp.window.move({ direction = "l" }))
      hl.bind("SUPER SHIFT + L", hl.dsp.window.move({ direction = "r" }))
      hl.bind("SUPER SHIFT + K", hl.dsp.window.move({ direction = "u" }))
      hl.bind("SUPER SHIFT + J", hl.dsp.window.move({ direction = "d" }))
      hl.bind("SUPER + mouse:272", hl.dsp.window.move(), { mouse = true })
      hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
      hl.bind("SUPER CONTROL + H", hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
      hl.bind("SUPER CONTROL + L", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })
      hl.bind("SUPER CONTROL + K", hl.dsp.window.resize({ x = 0, y = -25 }), { repeating = true })
      hl.bind("SUPER CONTROL + J", hl.dsp.window.resize({ x = 0, y = 25 }), { repeating = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

      hl.bind("SUPER + escape", hl.dsp.focus({ workspace = "special" }))
      hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
      hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
      hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
      hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
      for i = 1, 10 do
      	hl.bind("SUPER + " .. (i % 10), hl.dsp.focus({ workspace = tostring(i % 10) }))
      end
      for i = 1, 10 do
      	hl.bind("SUPER SHIFT + " .. (i % 10), hl.dsp.focus({ workspace = tostring(i % 10) }))
      end
      hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "previous" }))
    '';
}
