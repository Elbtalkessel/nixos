#!/usr/bin/env sh
# Sync clipboard between X11 and Wayland using xclip, wl-clipboard and clipnotify

while clipnotify; do
    xclip -o | wl-copy
done &
