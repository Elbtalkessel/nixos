#!/bin/sh

# Initial NixOS setup.

# Install home manager.
# See https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
sudo nix-channel --update
