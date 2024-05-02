#!/usr/bin/env sh

# Recursively unmount all mounts in /mnt
unmount -R /mnt

# Deactivate volume group vg
vgchange -a n vg

# Close encrypted volume
cryptsetup close root
