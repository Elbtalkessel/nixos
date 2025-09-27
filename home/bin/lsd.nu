#!/usr/bin/env nu

def dirs []: nothing -> list {
  $env.XDG_DATA_DIRS
  | split row ":"
  | each {|| $"($in)/applications"}
}

def "main dirs" []: nothing -> list {
  dirs
}

# Lists all deskop files at known locations.
# Doesn't allow passthrough arguments :(
def main []: nothing -> table {
  ls ...(dirs)
}
