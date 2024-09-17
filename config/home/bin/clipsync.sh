#!/usr/bin/env sh
# Clipboard utilities

# Reads stdin and sends a notification if the value is different from the last one.
# Usage: echo "Hello" | clipboard notify
notify() {
  value=$(cat)
  notify-send "Clipboard" "$value"
}

# Watches the clipboard and sends a notification when it changes.
watch() {
  # clipboard.sh must be in PATH and symlinked clipboard to work.
  wl-paste --type text --watch clipsync notify &
}

"$@"
