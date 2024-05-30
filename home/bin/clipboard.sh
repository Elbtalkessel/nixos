#!/usr/bin/env sh
# Clipboard utilities

# Reads stdin and sends a notification if the value is different from the last one.
# Usage: echo "Hello" | clipboard notify
notify() {
  value=$(cat)
  # Compare the value to the last value to prevent spamming.
  if [ -f /tmp/clipboard ] && [ "$(< /tmp/clipboard)" = "$value" ]; then
    return
  fi
  # Save the value to the clipboard file, isn't perferct as clipboard may contain sensitive data.
  # But it's good enough for me.
  echo -n "$value" > "/tmp/clipboard"
  notify-send "Clipboard" "$value"
}

# Watches the clipboard and sends a notification when it changes.
watch() {
  # clipboard.sh must be in PATH and symlinked clipboard to work.
  wl-paste --type text --watch clipboard notify &
}

"$@"
