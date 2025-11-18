#!/usr/bin/env nu

# Returns the main keyboard.
def get-kb []: nothing -> record {
  hyprctl devices -j 
  | from json 
  | get "keyboards" 
  | where main == true 
  | first
}

# Cycles between given layouts.
# FIXME: returns `layout idx out of range of 4` if "it" layout present :(
def "main cycle" [...layouts: string] {
  let kb = (get-kb)
  let ac = $kb.active_layout_index
  let layouts = (
    $kb.layout
    | split row ","
    | enumerate
    | where $it.item in $layouts
  )
  let next = try {
    $layouts | where $it.index > $ac | first
  } catch {
    $layouts | first
  }
  hyprctl switchxkblayout $kb.name $next.index
}

# Switches to next layout.
def "main next" [] {
  hyprctl switchxkblayout (get-kb).name next
}

# The `hyprctl switchxkblayout` command wrapper for switching
# layout of a "main" keyboard.
# By default switches layout to a given index.
def main [index: number] {
  hyprctl switchxkblayout (get-kb).name $index
}
