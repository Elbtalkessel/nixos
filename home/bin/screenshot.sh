#!/usr/env/bin bash

FILEPATH=$(xdg-user-dir PICTURES)/Screenshots/$(date +'%s').png
if [ ! -z $(pgrep slurp) ]; then
  pkill slurp
  sleep 1
  grim $FILEPATH
  if [ $? -ne 0 ]; then
    notify-send "Screenshot" "Cancelled."
    exit 1
  fi
else
  grim -g "$(slurp)" $FILEPATH
  if [ $? -ne 0 ]; then
    notify-send "Screenshot" "Cancelled."
    exit 1
  fi
fi

wl-copy -t image/png < $FILEPATH
if [ $? -ne 0 ]; then
  notify-send "Screenshot" "Failed to copy to clipboard. Is wl-copy installed?"
  exit 1
fi

if [ "$1" = "only-copy" ]; then
  rm $FILEPATH
  notify-send "Screenshot" "Copied to clipboard."
  exit 0
fi

notify-send "Screenshot" "Saved to $FILEPATH and copied to clipboard."
