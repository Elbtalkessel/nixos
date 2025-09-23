#!/usr/bin/env nu

# Returns the main keyboard.
def get-kb []: nothing -> record {
  hyprctl devices -j 
  | from json 
  | get "keyboards" 
  | where main == true 
  | first
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
