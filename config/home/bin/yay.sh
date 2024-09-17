#!/usr/bin/env bash

# I hate nix clis
while [[ $# -gt 0 ]]; do
  case $1 in
    -s)
      shift
      nix-search "$@"
      exit 0
      ;;
    -i)
      shift
      nix-search -d "$@" | less
      exit 0
      ;;
    -S)
      shift
      nix-shell -p "$@"
      exit 0
      ;;
    *)
      echo "-s - search for a package."
      echo "-i - search for a package details."
      echo "-S - temporary install a package."
      exit 0
      ;;
  esac
done

"$@"
