{pkgs, ...}: {
  # Clipboard related configuration.

  home.packages = with pkgs; [
    wl-clipboard
    (writeShellScriptBin "clipboard" (builtins.readFile ../bin/clipboard.sh))
  ];

  # autostart
  wayland.windowManager.hyprland.settings."exec-once" = [
    "clipboard watch" # watch x11 and wayland clipboard changes and send notification
  ];
}
