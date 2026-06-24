#!/usr/bin/env nu


# Is device screen on?
def is-screen-on [address?: string] {
  if ($address != null) {
    return true
  }
  (
    adb ...([] | append-address $address "adb") shell dumpsys input_method
    | grep mInteractive
    | str trim
    | parse "{_}={value}"
    | get value
    | first
  ) == "true"
}

# Interactive app select by apps's name, returns app's reverse domain notation
# usable for launching it.
def interactive-app-select [address?: string]: nothing -> string {
  let apps = (
    scrcpy ...([--list-apps] | append-address $address)
    | grep -P '^ \(*|-\)'
    | lines
    | str trim
    | parse --regex '(?!<type>\*|-)\s(?<name>[^\t]+)\s+(?<app>.*)'
    | reduce --fold {} {|it, acc| $acc | upsert $it.name $it.app}
  )
  let sel = (
    $apps
    | columns
    | str join "\n"
    | fzf
  )
  ($apps | get $sel)
}

def append-if [expr: bool, items: list]: list -> list {
  if ($expr) {
    $in | append $items
  } else {
    $in
  }
}

def append-address [address?: string, type: string = "scrcpy"]: list -> list {
  if ($address == null) {
    if ($type != "adb") {
      # Force USB if address is not set.
      $in ++ ["-d"]
    } else {
      $in
    }
  } else {
    if ($type == "adb") {
      let p = $address | parse "{host}:{port}" | first
      $in ++ [$"-H($p.host)", $"-P($p.port)"]
    } else {
      $in ++ [$"--tcpip=($address)"]
    }
  }
}

# Audio only passthrough.
def "main a" [
  --address (-a): string  # host:port
] {
  scrcpy ...(
    [--no-window --audio-buffer=200]
    | append-address $address
  )
}

# Launch an app using virtual display and turn off device display.
def "main l" [
  --address (-a): string  # host:port
] {
  let app = interactive-app-select $address
  let isOff = (not (is-screen-on $address))
  if ($isOff) {
    adb ...([] | append-address $address "adb") shell input keyevent KEYCODE_WAKEUP
  }
  scrcpy ...(
    [
      --new-display=2560x1440
      --mouse=uhid
      --keyboard=uhid
      $"--start-app=($app)"
    ]
    | append-address $address
    | append-if ($isOff) [--turn-screen-off --power-off-on-close]
  )
}

# Control an android device using physical mouse and keyboard simulation.
# Sleep on exit.
def "main c" [
  --address (-a): string  # host:port
] {
  scrcpy ...(
    [
      --mouse=uhid
      --keyboard=uhid
    ]
    | append-address $address
    | append-if (not (is-screen-on $address)) [--stay-awake --power-off-on-close]
  )
}

# Reverse ssh, maps 2222 on android to 22 on host
# allowing access host device from android device.
# Function by itself is simply, here only for documentation.
def "main revssh" [
  --help (-h): bool  # print help for subsommand
] {
  if ($help) {
    let _TERM_HOME = "/data/data/com.termux/files/home"
    print $"
    Requires sshd service to run on host and ssh client on device.
    Requires root debugging enabled temporary, to copy pub key from device
    and write ssh config to device. For normal operation it can be disabled.

    Termux:(ansi bg_k)
    pkg install openssh
    cd ~/.ssh
    ssh-keygen -t ed25519 -C 'user@device'(ansi rst)

    Host:(ansi bg_k)
    adb root
    adb shell cat ($_TERM_HOME)/.ssh/id_ed25519.pub
    | save --append ~/.ssh/authorized_keys
    [
      'Host name',
      '  User name',
      '  IdentityFile ($_TERM_HOME)/.ssh/id_ed25519'
      '  Port 2222'
    ] | str join \"\\n\" | adb shell tee >> ($_TERM_HOME)/.ssh/config
    adb kill-server
    adb reverse tcp:2222 tcp:22(ansi rst)

    Termux:(ansi bg_k)
    ssh omen(ansi rst)
    "
  }

  try {
    systemctl is-enabled sshd
  } catch {|e|
    error make {msg: "It seems sshd is not running on host."}
  }
  print "Mapping 22(host) -> 2222(android)"
  adb reverse tcp:2222 tcp:22 | ignore
}

# Scrcpy aliases / combos. See subcommands for more.
def main [] {}
