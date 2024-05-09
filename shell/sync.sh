#!/bin/sh

TARGET="/etc/nixos"

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--target)
      TARGET=$2
      shift
      shift
      ;;
    -r|--rebuild)
      REBUILD=true
      shift
      ;;
    -c|--clone)
      CLONE=true
      shift
      ;;
    *)
      echo "Sync configuration files and rebuild"
      echo "  -t, --target    Define target directory, /etc/nixos/ by default"
      echo "  -r, --rebuild   Rebuild system configuration, false by default"
      echo "  -c, --clone     Sends whole parent directory to the target(-t) directory. --target(-t) is required. Omits hardware-configuration.nix if present and coping .git. Useful for sending to an external drive and then to another machine."
      shift
      ;;
  esac
done


if [ ! -d "$TARGET" ]; then
  echo "Target directory does not exist".
  exit 1
fi

if [ ! -z "$CLONE" ]; then
  if [ "$TARGET" == "/etc/nixos" ]; then
    echo "Target directory is invalid or not set."
    exit 1
  fi
  echo "Cloning system configuration"
  rsync -Parvz --exclude=hardware-configuration.nix --exclude=.git --exclude=.gitignore . $TARGET
elif [ "$TARGET" ]; then
  echo "Syncing system configuration"
  sudo rsync -Parvz ./nixos/ "$TARGET" --delete
  if [ ! -z "$REBUILD" ]; then
    sudo nixos-rebuild switch --show-trace
  fi
fi
