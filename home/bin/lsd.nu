#!/usr/bin/env nu

def dirs []: nothing -> list {
  $env.XDG_DATA_DIRS
  | split row ":"
  | each {|| $"($in)/applications"}
  | where {|i| $i | path exists}
}

def "main dirs" []: nothing -> string {
  dirs | str join "\n"
}

# Lists all deskop files at known locations.
# Doesn't allow passthrough arguments.
# Cannot be piped further, nushell limitation, returns plain text.
def main []: nothing -> string {
  ls ...(dirs) | get name | str join "\n"
}
