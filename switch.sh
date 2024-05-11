#!/usr/env/bin bash

set -e

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--home)
      shift
      SWITCH_HOME=true
      ;;
    -s|--system)
      shift
      SWITCH_SYSTEM=true
      ;;
    *)
      echo "CLI for system setup. Passes arguments to other scripts. Each script supports -h, --help for more information, for example ./cli.sh -i -h to see install script help."
      echo "  -h, --home       Apply home configuration"
      echo "  -s, --system     Apply system configuration"
      shift
      ;;
  esac
done



if [ ${SWITCH_HOME} ]; then
  # Calls `home-manager switch` and `hyprctl reload`.
  # For some reason Hyprland doesn't autoreload on configuration change.
  home-manager switch --flake ./
  hyprctl reload
fi

if [ ${SWITCH_SYSTEM} ]; then
  sudo nixos-rebuild switch --flake ./
fi
