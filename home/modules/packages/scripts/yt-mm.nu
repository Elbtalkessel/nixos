#!/usr/bin/env -S nu --stdin

let COOKIES = $"($env.XDG_STATE_HOME)/yt-mm/($env | get YT_USER? | default 'cookie').txt"
let ARCHIVE = $"($env.XDG_STATE_HOME)/yt-mm/archive.txt"
let MUSIC_DIR = $env.XDG_MUSIC_DIR
let PLAYLISTS = $"($env.XDG_DATA_HOME)/mpd/playlists"


# Move content of directories having `name` in their name it a directory
# named `name`.
# Example:
#   bob cool/alone/criminal.mp3
#   joe smooth x bob cool/toaster games/divein.mp3
# ->
#   bob cool/alone/criminal.mp3
#   bob cool/toaster games/divein.mp3
# Note: command will remove all empty directories afterwards.
def "main squash" [name: string] {
  mkdir $name
  ls $MUSIC_DIR
  | where type == dir
  | insert base {|it| $it.name | path basename}
  | where ($it.base | str downcase) =~ ($name | str downcase) and $it.base != $name
  | each {|it| rsync -Par --remove-source-files $"($it.name)/" $"($MUSIC_DIR)/($name)/"}
  ^find $MUSIC_DIR -depth -type d -empty -delete
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
def "main pls" [] {
  mkdir $PLAYLISTS
  glob $"($PLAYLISTS)/*.m3u" | where not ('[yt]' in $it) | each {|it| rm $it}
  glob $"($MUSIC_DIR)/**/*.{opus,mp3,flac}"
  | each {|it| {
    name: $it,
    group: ($it | str replace $"($MUSIC_DIR)/" "" | path split | first)
  }}
  | group-by group --to-table
  | each {|it|
    $it.items
    | get name
    | str join "\n"
    | save $"($PLAYLISTS)/($it.group).m3u"
  }
  mpc update
}


def "main whereis" [target: string] {
  print (match $target {
    "pl" | "playlist" => $PLAYLISTS
    "dl" | "download" => $MUSIC_DIR
    "ar" | "archive" => $ARCHIVE
    "co" | "cookies" => $COOKIES
  })
}


# Creates a local playlist based on a remote playlist content.
# Requires files to be already downloaded.
def --wrapped "main pls-from" [url: string, ...args] {
  let playlist_id = ($url | parse -r '^.*playlist\?list=(?<id>.*)' | get id | first)
  let work_dir = [$MUSIC_DIR .metafiles $playlist_id] | path join
  print $"(ansi xpurplea)->(ansi rst) ($work_dir)"

  if (not ($work_dir | path exists)) {
    print $"(ansi xpurplea)->(ansi rst) ($work_dir)"
    mkdir $work_dir
    (yt-dlp
      -P $work_dir
      --no-download
      --write-info-json
      $url
      ...$args
    )
  }

  let playlist_name = $"[yt] (open (ls $work_dir | where name =~ $'($playlist_id)' | get name | first) | get title).m3u"
  let playlist_path = [$PLAYLISTS $playlist_name] | path join

  print $"(ansi xpurplea)<-(ansi rst) ($playlist_path)"
  ls $work_dir
  | where not ($playlist_id in ($it.name | path basename))
  | each {|it|
    {
      query: (printf '((artist == "%s") AND (album == "%s") AND (title == "%s"))' ...(open $it.name | get -o artist album title))
    }
  }
  | insert path {|it|
    let o = mpc search $'($it.query)'
    if (($o | str length) == 0) {
      print -e $"(ansi red)!(ansi rst) ($it.query)"
    }
    $o
  }
  | where path != ""
  | get path
  | str join "\n"
  | save -f $playlist_path

  mpc update
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
    --write-info-json
    ...$args
  )
}
