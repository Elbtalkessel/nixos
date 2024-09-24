#!/usr/bin/env sh
# Preloads (if missing) and temporary applies a wallpaper.
# Usage:
#   wallpaper <path>
alias hp=""
if ! hyprctl hyprpaper listloaded | grep $1
then
  hyprctl hyprpaper preload $1
fi
hyprctl hyprpaper wallpaper ",$1"
