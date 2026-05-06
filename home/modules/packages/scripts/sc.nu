#!/usr/bin/env nu


# Is device screen on?
def is-screen-on [] {
  (
    adb shell dumpsys input_method
    | grep mInteractive
    | str trim
    | parse "{_}={value}"
    | get value
    | first
  ) == "true"
}

# Interactive app select by apps's name, returns app's reverse domain notation
# usable for launching it.
def interactive-app-select []: nothing -> string {
  let apps = (
    scrcpy --list-apps
    | grep -P '^ \(*|-\)'
    | lines
    | str trim
    | parse --regex '(?<type>\*|-)\s(?<name>[^\s\s\s]+)\s+(?<app>[^$]+)'
    | reduce --fold {} {|it, acc| $acc | upsert $it.name $it}
  )
  let sel = (
    $apps
    | columns
    | str join "\n"
    | fzf
  )
  ($apps | get $sel).app
}

# Audio only passthrough.
def "main a" [] {
  (scrcpy
    --power-off-on-close
    --no-window
    --audio-buffer=200
  )
}

# Launch an app using virtual display and turn off device display.
def "main l" [] {
  let app = interactive-app-select
  if (is-screen-on) {
    scrcpy --new-display=2560x1440 --start-app=$"($app)"
  } else {
    # screen is off, to run virtual display we need to turn it on termporary.
    adb shell input keyevent KEYCODE_WAKEUP
    scrcpy --new-display=2560x1440 --start-app=$"($app)" --turn-screen-off --power-off-on-close
  }
}

# Control an android device using physical mouse and keyboard simulation.
# Sleep on exit.
def "main c" [] {
  (scrcpy
    --stay-awake
    --mouse=uhid
    --keyboard=uhid
    --power-off-on-close
  )
}

# Scrcpy aliases / combos. See subcommands for more.
def main [] {}
