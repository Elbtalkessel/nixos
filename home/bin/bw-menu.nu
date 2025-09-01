#!/usr/bin/env nu
# Before using you need to login using `bw login` command.

let SESSION_CACHE = $"($env.XDG_RUNTIME_DIR)/bw-session";
let NAME_ID_CACHE = $"($env.XDG_RUNTIME_DIR)/bw-name-id.json";

# Caches { <name of an item in vault>: <id of the item> } mapping for faster search.
def cache-items []: nothing -> nothing {
  open $SESSION_CACHE 
  | bw list items --session $in
  | from json
  | reduce {|it| merge {$it.name: $it.id}} --fold {}
  | to json
  | save -f $NAME_ID_CACHE
}

# Unlocks vault and caches returned session key.
def cache-session []: nothing -> nothing {
  yad --button=Unlock:0 --fixed --form --field Password:H ""
  | split column "|" 
  | get column1 
  | get 0
  | bw unlock $in
  | rg 'export BW_SESSION="([^"]+)"' -or '$1'
  | save -f $SESSION_CACHE
}

# For given record, creates a tofi menu with keys of the record
# to select.
def select-record-key []: record -> string {
  $in
  | columns
  | str join "\n"
  | tofi
}

# Retrievs an item from vault by an ID from the stdin.
# Returns a record with secrets user may intersed in.
def get-bw-id []: string -> record {
  let i = (bw get item $in --session (open $SESSION_CACHE) | from json)
  { username: $i.login.username, password: $i.login.password } 
  | merge (
    $i.fields? 
    | default [] 
    | reduce {|it| merge {$it.name: $it.value}} --fold {}
  )
}

def has-content []: string -> bool {
  ($in | path exists) and not ((cat $in) | is-empty)
}

def main []: nothing -> nothing {
  # disable self signed cert verification
  $env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
  if not ($SESSION_CACHE | has-content) {
    cache-session
  }
  if not ($NAME_ID_CACHE | has-content) {
    cache-items
  }
  let n = open $NAME_ID_CACHE
  let i = $n | get ($n | select-record-key) | get-bw-id
  $i | get ($i | columns | str join "\n" | tofi) | wl-copy
  notify-send "Copied!"
}

