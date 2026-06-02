_: {
  xdg.configFile."hypr/hyprland/device.lua".text = # lua
    ''
      -- DEVICE
      -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
      hl.device({
      	kb_options = "caps:none,grp:alt_space_toggle",
      	name = "at-translated-set-2-keyboard",
      })
    '';
}
