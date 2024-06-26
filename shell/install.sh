#!/usr/bin/env sh

source ./shell/common.sh
justHelp $1 "Install NixOS. Note you need run setup script first or mount script to re-mount already setting up partitions."
asRoot

echo "Installing NixOS"

# See https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
nix-channel --update
nixos-install
