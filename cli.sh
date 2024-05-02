#!/usr/bin/env sh

set -e

while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--install)
      shift
      source ./shell/install.sh $@
      exit 0
      ;;
    -m|--mount)
      shift
      source ./shell/mount.sh $@
      exit 0
      ;;
    -s|--setup)
      shift
      source ./shell/setup.sh $@
      exit 0
      ;;
    -sy|--sync)
      shift
      source ./shell/sync.sh $@
      exit 0
      ;;
    -test)
      shift
      source ./shell/test.sh $@ 
      exit 0
      ;;
    *)
      echo "CLI for system setup. Passes arguments to other scripts. Each script supports -h, --help for more information, for example ./cli.sh -i -h to see install script help."
      echo "  -i, --install    Install packages"
      echo "  -m, --mount      Mount partitions"
      echo "  -s, --setup      Setup system"
      echo "  -sy, --sync      Sync configuration files"
      shift
      ;;
  esac
done

