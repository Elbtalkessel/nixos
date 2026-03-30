#!/usr/bin/env bash
set -e

# Strip trailing slash if present.
MUSIC_DIR=${1%/}
PLAYLIST_DIR=${2%/}
PROG=$(basename "$0")

if ! test -d "$MUSIC_DIR" || ! test -d "$PLAYLIST_DIR"; then
  echo "$PROG directory-wise m3u generator"
  echo
  echo "Usage: <music-directory> <playlist-directory>"
  echo
  echo "Given 'Music/FooFighters/abc.mp3' directory,"
  echo "running '$PROG Music/ Playlists/'"
  echo "will create 'Playlists/FooFighters.m3u' with '<full-path-to>/abc.mp3' content."
  exit 1
fi

# IFS= disable word splitting, our paths may contain spaces.
# Split by null character.
# Read from the descriptor 3.
while IFS= read -r -d $'\0' dir <&3; do
  echo "Processing $dir"
  name=$(basename "$dir")
  path="${PLAYLIST_DIR}/${name}.m3u"
  find "$dir" -type f -name "*.mp3" -o -name "*.flac" 2>/dev/null > "$path"
  echo "Added $(wc -l "$path") songs to $name"
  echo ""
done 3< <(find "$MUSIC_DIR" -maxdepth 1 -type d -not -path '*/.*' -not -path "$MUSIC_DIR" -print0)
# Find all directories under the root dir ignoring dot dirs or root dir itself.
# Separate results by null character, the null character is only character invalid as path name.
# Direct stream to the descriptor 3.

# Close descriptor.
exec 3<&-

echo 'Great success. Use "mpc update" to update database.'
