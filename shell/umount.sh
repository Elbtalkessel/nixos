#!/usr/bin/env sh

source ./shell/common.sh
justHelp $1 "Unmounts all mounts in /mnt and deactivates and encrypts volume group vg."
asRoot

# Recursively unmount all mounts in /mnt
umount -R /mnt

# Deactivate volume group vg
vgchange -a n vg

# Close encrypted volume
cryptsetup close root
