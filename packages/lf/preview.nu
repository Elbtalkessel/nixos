#!/usr/bin/env nu


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
      if ($in.key == 'size') {
        $in.value | into filesize | format filesize MB
      } else {
        $in.value
      }} 
  | str join "\n"
}

def main [f: string, w: number, h: number, x: number, y: number]: nothing -> string {
  $f 
  # TODO: rewrite using media query
  | parse -r "\\.(?<ext>[0-9a-zA-Z]+$)" 
  | default -e ([{ext: ""}])
  | get ext 
  | first 
  | str downcase
  | match $in {
    tgz | tar | zip | 7z | gz | xz | lzma | bz | bz2 | bz3 | lz4 | sz | zst | br => (ouch l $"($f)")
    [1..8] => (man $"($f)" | col -b)
    flac => (metaflac --list --block-type=VORBIS_COMMENT $"($f)")
    mp3 => (id3v2 --list $"($f)")
    mp4 | mkv => ($f | video)
    _ => (bat --color=always --style=plain --pager=never $"($f)")
  }
}
