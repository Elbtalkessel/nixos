#!/usr/bin/env sh

cache="/home/risus/.cache/wallpaper"
if [ "$1" != "$cache" ]
then
  ln -sf "$1" "$cache" 2>/dev/null
fi

hyprctl hyprpaper unload "$cache"
hyprctl hyprpaper preload "$cache"
hyprctl hyprpaper wallpaper ",$cache"
