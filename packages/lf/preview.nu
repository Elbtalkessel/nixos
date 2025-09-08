#!/usr/bin/env nu

def file-mime-type []: list<string> -> list<record> {
  $in 
  | each {||
    file --mime-type $in
    | parse "{name}: {type}/{subtype}"
    | into record
  }
}

def is-archive [subtype: string]: nothing -> bool {
  [x-tar x-bzip2 gzip x-7z-compressed x-gtar zip] 
  | any {|| $in | str contains $subtype}
}

def merge-mime-supertype []: list<record> -> list<record> {
  $in
  | each {||
    if (is-archive $in.subtype) {
      $in | merge {supertype: "archive"}
    } else {
      $in | merge {supertype: $in.type}
    }
  }
}

def video []: string -> string {
  (
    ffprobe 
    -v error 
    -show_entries format=filename,duration,size 
    -of default=noprint_wrappers=1 
    # format duration using hh:mm:ss
    -sexagesimal 
    $in
  )
  | split row -r '\n' 
  | parse '{key}={value}' 
  | each {||
      match $in.key {
        size => ($in.value | into filesize | format filesize MB)
        filename => ($in.value | path basename)
        _ => $in.value
      }
  } 
  | str join "\n"
}

def main [f: string, w = 0, h = 0, x = 0, y = 0]: nothing -> string {
  $f 
  | get-mime-type
  | merge-mime-supertype
  | match $in {
    archive => (ouch l $"($f)")
    audio => {

    }
    mp3 => (id3v2 --list $"($f)")
    video => ($f | video)
    _ => (bat --color=always --style=plain --pager=never $"($f)")
  }
}
