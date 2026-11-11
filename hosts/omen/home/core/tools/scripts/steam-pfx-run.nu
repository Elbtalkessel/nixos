#!/usr/bin/env nu

let STEAM_DIR = "~/.local/share/Steam"

def get-manifests [] {
    glob $"($STEAM_DIR)/steamapps/*.acf"
    | each {|i|
        rg "(appid|name|installdir)" $i
        | lines
        | str trim
        | parse -r '^"(?P<key>\w+)"\s+"(?<value>.*)"'
        | transpose --header-row
        | insert pfx {|i| $"($STEAM_DIR)/steamapps/compatdata/($i.appid)" | path expand}
        | insert gamedir {|i| $"($STEAM_DIR)/steamapps/common/($i.installdir)" | path expand}
        | insert type {|i|
            # Works until you have a game with Proton in title. I don't anyway.
            if ($i.installdir | str starts-with "SteamLinuxRuntime") {
                "runtime"
            } else if ($i.installdir | str starts-with "Proton" ) {
                "proton"
            } else {
                "game"
            }
        }
    }
    | flatten
}

def "main manifests" [] {
    get-manifests | to md --pretty
}

def main [
  exe: string # full path to executable to run in selected prefix.
] {
    print "Select a game:"
    let game = get-manifests | where type == "game" | input list -d name

    print "Select runner:"
    let proton = get-manifests | where type == "proton" | input list -d name
    let runner = $"($proton.gamedir)/proton"
    if not ($runner | path exists) {
        error make { msg: $"proton executable not found in ($proton.gamedir)." }
    }

    if not ($game.pfx | path exists) {
        error make { msg: $"game prefix not found in ($game.pfx), try run the game once." }
    }

    with-env {
        STEAM_COMPAT_DATA_PATH: $game.pfx
        WINEPREFIX: $game.pfx
        SteamAppId: $game.appid
        STEAM_COMPAT_CLIENT_INSTALL_PATH: $STEAM_DIR
        STEAM_APPS_PATH: $"($STEAM_DIR)/steamapps"
        PROTON_PATH: $proton.gamedir
    } { run-external $runner run $exe }
}
