#!/usr/bin/env nu

def main [name: string] {
  if ((ps | where name =~ "eww" | length) > 0 and ($name in (eww active-windows))) {
    eww close $name
  } else {
    eww open $name
  }
}
