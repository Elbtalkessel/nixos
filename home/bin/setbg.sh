#!/usr/bin/env sh

cache="/home/risus/.cache/wallpaper"
if [ -n "$1" ] && [ ! -f "$1" ]
then
  exit 1
fi

if [ -f "$1" ]
then
  ln -sf "$1" "$cache" 2>/dev/null
fi

hyprctl hyprpaper unload "$cache"
hyprctl hyprpaper preload "$cache"
hyprctl hyprpaper wallpaper ",$cache"
