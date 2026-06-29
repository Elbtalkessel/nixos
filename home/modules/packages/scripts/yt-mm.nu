#!/usr/bin/env -S nu --stdin

let COOKIES = $"($env.XDG_STATE_HOME)/yt-mm/($env | get YT_USER? | default 'cookie').txt"
let ARCHIVE = $"($env.XDG_STATE_HOME)/yt-mm/archive.txt"
let MUSIC_DIR = $env.XDG_MUSIC_DIR
let PLAYLISTS = $"($env.XDG_MUSIC_DIR)/.playlists"


def --wrapped "main refresh" [...args] {
  (yt-dlp
    --download-archive $ARCHIVE
    -P $MUSIC_DIR
    -x -o "%(artist)s/%(album)s/%(title)s.%(ext)s"
    --cookies $COOKIES
    ...$args
  )
}


# Organizes library by primary name,
# Eg. Several directories contain a "name", all
# will be merged under single "name" loosing original
def "main organize" [name: string] {
  # locate primary directory, first case insensetive,
  # then normalize to given.
  let primaries = (
    ls $MUSIC_DIR
    | where type == dir
    | where {|it| ($it.name | str downcase) == ($name | str downcase)}
  )
  let primary = if (($primaries | length) == 0) { mkdir $name; $name } else { $primaries | first | get name }

  ls $MUSIC_DIR
  | where type == dir and name =~ $"($name)" and name != $"($primary)"
  | each {|it|
    rsync -Prv --remove-source-files $"($it.name)/" $"($primary)/"
    gtrash put -r -- $it.name
  }
}


def "main mkpls" [] {
  mkdir $PLAYLISTS
  genplaylists $MUSIC_DIR $PLAYLISTS
}


def "main whereis" [target: string] {
  print (match $target {
    "pl" | "playlist" => $PLAYLISTS
    "dl" | "download" => $MUSIC_DIR
    "ar" | "archive" => $ARCHIVE
    "co" | "cookies" => $COOKIES
  })
}


def main [] {}
