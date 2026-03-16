#!/usr/bin/env -S nu --stdin

def --wrapped tmsu_ [...rest] {
  tmsu ...$rest
}

def is-dir [value: string]: nothing -> bool {
  ($value | path type) == "dir"
}

# Returns two value list: [width, height].
def get-image-resolution []: string -> list<number> {
  identify -format "%w %h" $in
  | split row " "
  | each {|i| $i | into int}
}

# Image quality estimation based on megapixels and rounded to the
# nearest whole number.
def image-quality-tag []: string -> string {
  let v = $in | get-image-resolution
  $"quality=(($v.0 * $v.1 / 1_000_000) | math round | into string)"
}

# Returns aspect ratio name based on an image resolution.
def image-aspect-tag []: string -> string {
  let v = $in | get-image-resolution
  if ($v.0 < $v.1) {
    "portrait"
  } else if ($v.0 > $v.1) {
    "landscape"
  } else {
    "square"
  }
}

def get-unique-tags [...paths: string]: nothing -> list<string> {
  tmsu_ tags -1 ...$paths
  | split row "\n"
  | where {|it| not ($it | str ends-with ":") and $it != ""}
  | uniq
}

def tag [path: string, tags: string]: nothing -> string {
  if (is-dir $path) {
    tmsu_ tag $path --recursive --tags $tags
  } else {
    tmsu_ tag $path --tags $tags
  }
  return $path
}

def untag [
  tags: string,
  path: string,
]: nothing -> string {
  if (is-dir $path) {
    if ($tags == null) {
      tmsu_ untag --recursive --all $path
    } else {
      tmsu_ untag --recursive --tags $tags $path
    }
  } else {
    if ($tags == null) {
      tmsu_ untag --all $path
    } else {
      tmsu_ untag --tags $tags $path
    }
  }
  return $path
}

# All unique tags of a file(s).
def "main show" []: string -> string {
  get-unique-tags ...($in | lines) | str join "\n"
}

# Tags one or multiple paths.
def "main add" [tags: string]: string -> nothing {
  $in
  | lines
  | each {|it| tag $it $tags}
}

# Remove a tag or all tags if -t omitted.
def "main rm" [--tags (-t): string]: string -> nothing {
  $in
  | lines
  | each {|it| untag $it $tags}
}

# Sets a tag indicating image's aspect ratio.
def "main set-aspect-tag" []: string -> nothing {
  $in
  | lines
  | par-each -t 2 {|it| tag $it ($it | image-aspect-tag)}
}

# Sets a quality=<int> tag. Quality is based on image's megapixels.
def "main set-quality-tag" []: string -> nothing {
  $in
  | lines
  | par-each -t 2 {|it| tag $it ($it | image-quality-tag)}
}

# TMSU helper functions, see --help for more.
def main [] {}
