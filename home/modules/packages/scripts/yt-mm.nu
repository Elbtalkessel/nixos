#!/usr/bin/env -S nu --stdin


let STATE_DIR = $"($env.XDG_STATE_HOME)/yt-mm"
let ARCHIVE = $"($STATE_DIR)/archive.txt"
let MUSIC_DIR = $env.XDG_MUSIC_DIR
let PLAYLISTS = $"($env.XDG_DATA_HOME)/mpd/playlists"


# Merge directories with LIKE matching into a directory with EXACT match.
@example "Move content of `~/Music/joe smooth x bob cool` to the `~/Music/bob cool` directory" { yt-mm fs-sqash `bob cool` }
def "main fs-squash" [name: string] {
  mkdir $name
  ls $MUSIC_DIR
  | where type == dir
  | insert base {|it| $it.name | path basename}
  | where ($it.base | str downcase) =~ ($name | str downcase) and $it.base != $name
  | each {|it| rsync -Par --remove-source-files $"($it.name)/" $"($MUSIC_DIR)/($name)/"}
  ^find $MUSIC_DIR -depth -type d -empty -delete
}


# Organize audio files by their tags.
@example "Move audio files to [artist]/[album]/[title].<ext>" { yt-mm fs-tagmv }
def "main fs-tagmv" [] {
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


# Tags audio files based on path directly under the MUSIC_DIR, [artist]/[album]/[title].opus
def "main tag-by-path" [] {
  glob $'($MUSIC_DIR)/**/*.opus'
  | parse -r ('(?P<path>' + $MUSIC_DIR + '/(?P<artist>[^/]+)/(?P<album>[^/]+)/(?P<title>[^/]+)\.opus)')
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
  | each {|it|
    $it.tags
    | opustags -i $it.path --set-all --in-place
  }
}


def pls-by-dir [] {
  glob $"($PLAYLISTS)/\\[d\\]*.m3u" | each {|it| rm $it}
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
    | save $"($PLAYLISTS)/[d] ($it.group).m3u"
  }
}


def pls-by-meta [include_albums: bool] {
  glob $"($MUSIC_DIR)/**/*.info.json"
  | each {|it| open $it }
  | where _type != "playlist"
  | group-by --to-table playlist
  | where {|it| $include_albums or (not ($it.playlist | str starts-with "Album -"))}
  | each {|it|
    {
      playlist: ($"($PLAYLISTS)/[yt] ($it.playlist).m3u"),
      queries: (
        $it.items
        | each {|it|
          ["artist" "album" "title"]
          | each {|i| [$i ($it | get -o $i)]}
          | where $it.1 != null
          | reduce --fold [] {|c a| $a | append (printf '(%s == "%s")' ...$c)}
          | str join " AND "
        }
      )
    }
  }
  | insert paths {|it|
    $it.queries
    | each {|it|
      let query = ("(" + $it + ")")
      let result = try {
        mpc search $query
      } catch {|e|
        error make {msg: $it inner: [$e]}
      }
      if ($result == "") {
        print -e $"(ansi red)!(ansi rst) no result for: ($query)"
      }
      $result
    }
    | where $it != ""
  }
  | each {|it|
    if (($it.paths | length) == 0) {
      print -e $"(ansi red)!(ansi rst) no items for: ($it.playlist)"
    } else {
      $it.paths
      | str join "\n"
      | save -f $it.playlist
      print $"Wrote ($it.paths | length | into string) items to ($it.playlist)"
    }
  }
}

# Creates playlist files in PLAYLISTS directory.
@example "Create playlists from all *.info.json files" {yt-mm pls -t "yt"}
@example "Create playlists from all *.info.json files including the one for albums" {yt-mm pls -t "yt" --yt-album}
@example "Create playlists for every top level directory" {yt-mm pls -t "dir"}
def "main pls" [
  --types (-t): string@[ "dir" "yt" ]         # Type of playlists to generate. All by default excludng album playlists.
  --yt-album                                  # For "yt" type, include album playlists.
] {
  mkdir $PLAYLISTS
  if ($types != null) { $types } else { ["dir" "yt"] }
  | each {|t|
    match $t {
      # The dir type should execute first, it will populate mpd database, for yt playlists to query from.
      "dir" => (pls-by-dir; mpc update)
      "yt" => (pls-by-meta $yt_album; mpc update)
      _ => (error make --unspanned { msg: "Bad type."})
    }
  }
}


# Commands to download and manage music from YouTube.
@example "Re-download only metafiles." { yt-mm --skip-download --no-download-archive --write-info-json https://www.youtube.com/playlist?list=... }
@example "Download audio and metafiles." { yt-mm --write-info-json https://www.youtube.com/playlist?list=... }
def --wrapped main [
  --cookies (-c): string  # Cookie file to use.
  --help (-h)             # Show this help.
  ...args                 # Flags to pass to yt-dlp call.
] {
  (yt-dlp
    --download-archive $ARCHIVE
    -P $MUSIC_DIR
    # default audio format is best, best quality (0).
    -x --audio-quality 0
    -o "%(artist,channel)s/%(album,playlist_title)s/%(track_number,playlist_index)s - %(title)s.%(ext)s"
    --continue
    --convert-thumbnails jpg
    --embed-thumbnail
    --embed-metadata
    --embed-chapters
    --xattrs
    --extractor-args "youtube:lang=en"
    --no-write-thumbnail
    ...(if ($cookies != null) {[--cookies $cookies]} else {[]})
    ...$args
  )
}
