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
    notify-send "Screenshot" "Saved to $FILEPATH."
  else
    wl-copy -t image/png < $TEMPFILE
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
  ERROR=$(wl-screenrec -g "$(slurp)" -f $FILEPATH 2>&1 >/dev/null)
  if [ $ERROR ]; then
    notify-send "Screenrecord" "$ERROR"
    exit 1
  fi
  notify-send "Screenrecord" "Saved to $FILEPATH."
  wl-copy $FILEPATH
fi

