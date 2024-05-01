#!/bin/sh

set -e

while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--system)
      SYNC_SYS=true
      shift
      ;;
    *)
      echo "Sync configuration files and rebuild"
      echo "  -s, --system    Sync /etc/nixos/"
      echo "  -u, --user      Sync /home/$USER/.config/home-manager/"
      shift
      ;;
  esac
done

if [ ! -z "$SYNC_SYS" ]; then
  echo "Syncing system configuration"
  sudo rsync -Parvz ./nixos/ /etc/nixos/ --delete
  sudo nixos-rebuild switch
fi
