#!/usr/bin/env sh

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Unmounts all mounts in /mnt and deactivates and encrypts volume group vg."
  exit 0
fi

# Recursively unmount all mounts in /mnt
umount -R /mnt

# Deactivate volume group vg
vgchange -a n vg

# Close encrypted volume
cryptsetup close root
