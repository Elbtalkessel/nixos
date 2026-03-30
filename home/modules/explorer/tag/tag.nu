#!/usr/bin/env -S nu --stdin

def --wrapped tmsu_ [...rest] {
  tmsu ...$rest
}

def is-dir [value: string]: nothing -> bool {
  ($value | path type) == "dir"
}

# Returns two value list: [width, height].
def get-image-resolution []: string -> list<number> {
  # Regardless of file type get width and height from the first frame [0].
  # If ffmpeg is installed, video formats will be supported as well.
  identify -format "%w %h" $"($in)[0]"
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
  # Just in case, -1 outputs clean strings, but idk.
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
  path: string,
  tags?: string,
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
def "main add" [tags: string]: string -> list<string> {
  $in
  | lines
  | each {|path| tag $path $tags}
}

# Remove a tag or all tags if -t omitted.
def "main rm" [--tags (-t): string]: string -> list<string> {
  $in
  | lines
  | each {|path| untag $path $tags}
}

# Untags a file and removes it.
def "main fs-rm" []: string -> list<string> {
  $in
  | lines
  | each {|path| untag $path; rm $path; $path}
}

# Sets a tag indicating image's aspect ratio.
def "main set-aspect" [
  --override (-o) = false  # If set, will check if aspect ratio is set on a file before.
]: string -> list<string> {
  let f = if ($override) {
    {|it| true}
  } else {
    {|it| (get-unique-tags $it | where {|tag| not ($tag in [landscape portrait square]) | length) == 0}
  }

  $in
  | lines
  | where $f
  | par-each -t 2 {|path| tag $path ($path | image-aspect-tag)}
}

# Sets a quality=<int> tag. Quality is based on image's megapixels.
def "main set-quality" [
  --override (-o) = false  # If set, will check if quality already set on an image.
]: string -> list<string> {
  let f = if ($override) {
    {|it| true}
  } else {
    {|it| (get-unique-tags $it | where {|tag| not ($tag | str starts-with "quality")} | length) == 0}
  }

  $in
  | lines
  | where $f
  | par-each -t 2 {|path| tag $path ($path | image-quality-tag)}
}

# TMSU helper functions, see --help for more.
def main [] {}
