#!/bin/sh
# WIDTHxHEIGHT/DPI
DISPLAY="1280x720/120"
cleanup() {
  echo "Removing overlay."
  adb shell settings put global overlay_display_devices none
}
trap cleanup INT TERM

echo "Creating $DISPLAY overlay."
adb shell settings put global overlay_display_devices $DISPLAY

echo "Querying last created overlays and showing it."
id=$(scrcpy --list-display | rg '\--display-id=(\d+)' -or '$1' | tail -1)
scrcpy --display-id="$id"
