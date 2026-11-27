#!/usr/bin/env bash
set -euxo pipefail
# Install script

HOST=couch

if [ "$1" == "vm" ]; then
    sed -i "s,/dev/nvme0n1,/dev/vda," hosts/${HOST}/disko.nix
fi

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./hosts/${HOST}/disko.nix
sudo nixos-install --flake .#${HOST} --no-root-password
reboot
