#!/usr/bin/env -S nu --stdin

let COOKIES = $"($env.XDG_STATE_HOME)/yt-mm/($env | get YT_USER? | default 'cookie').txt"
let ARCHIVE = $"($env.XDG_STATE_HOME)/yt-mm/archive.txt"
let MUSIC_DIR = $env.XDG_MUSIC_DIR
let PLAYLISTS = $"($env.XDG_MUSIC_DIR)/.playlists"


# Organizes library by primary name,
# Eg. Several directories contain a "name", all
# will be merged under single "name" loosing original
def "main squash" [name: string] {
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

# Move files based on their tags,
# MUSIC_DIR/[ARTIST]/[ALBUM]/[TITLE].opus
# Takes first found tag.
def "main mv-by-tag" [] {
  glob $'($MUSIC_DIR)/**/*.opus'
  | each {|it|
    let t = (opustags $it | lines | parse "{key}={value}")
    let dst = (([
      $MUSIC_DIR,
      ($t | where key == "ARTIST" | first).value,
      ($t | where key == "ALBUM" | first).value,
      ($t | where key == "TITLE" | first).value,
    ] | str join "/") + ".opus")
    if ($it != $dst) {
      mkdir ($dst | path dirname)
      mv -vn $"($it)" $"($dst)"
    }
  }
}


def tagit [] {
  $in
  | update artist {|it|
    $it.artist
    | split column ','
    | values
    | flatten
    | str trim
    | uniq
  }
  | each {|it|
    {
      path: ($it.path),
      tags: (
        $it.artist
        | each {|it| $"ARTIST=($it)"}
        | append $"ALBUM=($it.album)"
        | append $"TITLE=($it.title)"
        | str join "\n"
      )
    }
  }
}


# Tags an audio file based on path directly under MUSIC_DIR,
# [artist]/[album]/title.opus
def "main tag-by-path" [] {
  glob $'($MUSIC_DIR)/**/*.opus'
  | parse -r ('(?P<path>' + $MUSIC_DIR + '/(?P<artist>[^/]+)/(?P<album>[^/]+)/(?P<title>[^/]+)\.opus)')
  | tagit
  | each {|it|
    $it.tags
    | opustags -i $it.path --set-all --in-place
  }
}


# Generate playlists for each artist - directory.
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


# Downloads audio from Youtube, wrapper around `yt-dlp`.
def --wrapped main [...args] {
  (yt-dlp
    --download-archive $ARCHIVE
    -P $MUSIC_DIR
    # default audio format is best, best quality (0).
    -x --audio-quality 0
    -o "%(artist)s/%(album)s/%(track_number,playlist_index)s - %(title)s.%(ext)s"
    --cookies $COOKIES
    --continue
    --add-metadata
    --embed-thumbnail
    --convert-thumbnails jpg
    --embed-chapters
    --xattrs
    --extractor-args "youtube:lang=en"
    ...$args
  )
}
