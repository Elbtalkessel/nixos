#!/usr/bin/env sh

echo "Install home manager"
# See https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
echo "Installing NixOS"
nixos-install
