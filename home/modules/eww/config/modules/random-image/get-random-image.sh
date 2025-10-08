#!/bin/sh
find "$XDG_PICTURES_DIR" -type f \( -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.png' -o -iname '*.gif' \) | shuf -n1
