#!/usr/bin/env nu

def --wrapped tmsu_ [...rest] {
  tmsu --database $"($env.XDG_CONFIG_HOME)/tmsu/db" ...$rest
}

def get-mount-point [] {
  $"($env.HOME)/Tags"
}

# Lists tags of one or multiple $v.
def get-tags [...v: string]: nothing -> list<string> {
  tmsu_ tags -1 ...$v
  | split row "\n"
  | where {|it| not ($it | str ends-with ":") and $it != ""}
  | uniq
}

def is-dir [value: string]: nothing -> bool {
  ($value | path type) == "dir"
}

# Adds tags $t to a $v.
def tag [v: string, t: string] {
  if (is-dir $v) {
    tmsu_ tag $v --recursive --tags $"($t)"
  } else {
    tmsu_ tag $v --tags $"($t)"
  }
}

# Removes tags $t form a $v.
def untag [v: string, t: string] {
  if (is-dir $v) {
    if ($t == "") {
      tmsu_ untag --recursive --all $v
    } else {
      tmsu_ untag --recursive --tags $"($t)" $v
    }
  } else {
    if ($t == "") {
      tmsu_ untag --all $v
    } else {
      tmsu_ untag --tags $"($t)" $v
    }
  }
}

# Space separated tag list of one or multiple $v.
def "main show" [...v: string] {
  get-tags ...$v | str join " "
}

# Tags one or multiple $v.
def "main add" [...v: string, tags: string] {
  $v
  | split row "\n"
  | each {|it| tag $it $tags}
}

def "main rm" [...v: string -t,--tags: string = ""] {
  $v
  | split row "\n"
  | each {|it| untag $it $tags}
}

def "main search" [v: string] {
  [(get-mount-point) "queries" $"($v)"] | path join
}

def "main mount" [] {
  mkdir (get-mount-point)
  tmsu_ mount (get-mount-point)
}

def "main unmount" [] {
  tmsu_ unmount (get-mount-point)
}

def --wrapped main [...rest] {
  tmsu_ ...$rest
}
