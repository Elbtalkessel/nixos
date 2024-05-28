#!/usr/env/bin bash

while [[ $# -gt 0 ]]; do
  case $1 in
    shot)
      SCREENSHOT=true
      shift
      ;;
    record)
      SCREENRECORD=true
      shift
      ;;
    -s|--save)
      shift
      SAVE_OUTPUT=true
      ;;
    *)
      echo "Screen capture."
      echo "Usage: screenshot.sh [shot|record] [options]"
      echo ""
      echo "Options:"
      echo "  -s, --save       Save screenshot. Default is to copy to only clipboard."
      echo ""
      echo "To stop recording call the script again with the same arguments."
      shift
      ;;
  esac
done

if [ $SCREENSHOT ]; then
  FILEPATH=/media/pictures/capture/$(date +'%s').png
  TEMPFILE=$(mktemp)
  ERROR=$(grim -g "$(slurp)" $TEMPFILE 2>&1 >/dev/null)
  if [ $ERROR ]; then
    notify-send "Screenshot" "$ERROR"
    exit 1
  fi
  if [ $SAVE_OUTPUT ]; then
    mv $TEMPFILE $FILEPATH
    wl-copy $FILEPATH
  else
    wl-copy -t image/png < $TEMPFILE
    # Tempoarary (?) clipboard is not syncronized between wayland and x11 on hyprland,
    # the clipsync script only works for text.
    cat $TEMPFILE | xclip -selection clipboard -target image/png -i
    notify-send "Screenshot" "Copied to clipboard."
    rm $TEMPFILE
  fi
fi

if [ $SCREENRECORD ]; then
  if [ "$(pgrep -x wl-screenrec)" ]; then
    pkill -x wl-screenrec
    notify-send "Screenrecord" "Stopped recording."
    exit 0
  fi
  FILEPATH=/media/video/capture/$(date +'%s').mp4
  notify-send "Screenrecord" "Recording to $FILEPATH."
  wl-screenrec -g "$(slurp)" -f $FILEPATH
  notify-send "Screenrecord" "Saved to $FILEPATH."
  wl-copy $FILEPATH
fi

