_: {
  # https://man.archlinux.org/man/extra/waybar/waybar-hyprland-workspaces.5.en
  "disable-scroll" = true;
  "show-special" = true;
  "all-outputs" = true;
  "on-click" = "activate";
  # Options: icon, windows.
  "format" = "{icon}";
  "format-window-separator" = " ";
  "workspace-taskbar" = {
    # Looks like an unconfigurable ass.
    # If workspace is empty I'd like to have there a hollow circle.
    # Occupied - only icons of programs, without any circles.
    # But it is all or nothing.
    "enable" = false;
    "update-active-window" = true;
  };
  "format-icons" = {
    "active" = "";
    "special" = "󱊷";
    "empty" = "";
    # `empty` has lower priority than workspace ID.
    # Number 10 looks like ass because two digits but what else can I do.
  };
  "persistent-workspaces" = {
    "*" = 10;
  };
}
