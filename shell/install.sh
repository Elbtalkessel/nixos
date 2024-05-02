#!/usr/bin/env sh

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Install NixOS. Note you need run setup script first or mount script to re-mount already setting up partitions."
  exit 0
fi

echo "Install home manager"
# See https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
echo "Installing NixOS"
nixos-install
