#!/usr/bin/env sh
set -e

ROOT_DIR=/mnt/share/Music
PL_DIR=~/.local/share/mpd/playlists
while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--source)
      ROOT_DIR=$2
      shift
      shift
      ;;
    -d|--dest)
      PL_DIR=$2
      shift
      shift
      ;;
    *)
      echo "Create in the [--dest]($PL_DIR) playlists for each directory from the [--source]($ROOT_DIR) "
      echo "  -s, --source  Music directory, music shall be in sub directories."
      echo "  -d, --dest    Playlist directory."
      exit 0
      ;;
  esac
done

# Strip trailing slash if present.
ROOT_DIR="${ROOT_DIR%/}"
PL_DIR="${PL_DIR%/}"

if [ ! -d $ROOT_DIR ] || [ ! -d $PL_DIR ]
then
  echo "Music or playlist directory is missing or incorrect."
  echo "Music:    $ROOT_DIR"
  echo "Playlist: $PL_DIR"
  exit 1
fi

# IFS= disable word splitting, our paths may contain spaces.
# Split by null character.
# Read from the descriptor 3.
while IFS= read -r -d $'\0' dir <&3; do
  echo "Processing $dir"
  name=`basename "$dir"`
  path="${PL_DIR}/${name}.m3u"
  find "$dir" -type f -name "*.mp3" -o -name "*.flac" 2>/dev/null > "$path"
  echo "Added $(wc -l "$path") songs to $name"
  echo ""
done 3< <(find $ROOT_DIR -maxdepth 1 -type d -not -path '*/.*' -not -path $ROOT_DIR -print0)
# Find all directories under the root dir ignoring dot dirs or root dir itself.
# Separate results by null character, the null character is only character invalid as path name.
# Direct stream to the descriptor 3.

# Close descriptor.
exec 3<&-

echo 'Great success. Use "mpc update" to update database.'
