{ pkgs, ... }: {
  # Clipboard related configuration.

  home.packages = with pkgs; [
    wl-clipboard
    xclip
    clipnotify
    (writeShellScriptBin "clipsync" (builtins.readFile ../bin/clipsync.sh))
  ];

  # autostart
  wayland.windowManager.hyprland.settings."exec-once" = [
    "clipsync watch" # watch x11 and wayland clipboard changes and send notification
  ];
}
