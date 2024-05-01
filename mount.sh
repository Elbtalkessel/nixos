#!/usr/bin/env sh

BTRFS_MOUNT_OPT=defaults,ssd,noatime,compress=zstd

echo "Mounting root"
mount -t btrfs -o subvol=@,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt

echo "Creating mount points"
mkdir -p /mnt/{boot,boot/efi,home,root,srv,nix,var/cache,var/tmp,var/log,var/lib/docker,var/lib/libvirt}

echo "Mounting boot"
mount /dev/disk/by-label/boot /mnt/boot/efi

echo "Mounting subvolumes"
mount -t btrfs -o subvol=@nix,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/nix
mount -t btrfs -o subvol=@root,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/root
mount -t btrfs -o subvol=@srv,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/srv
mount -t btrfs -o subvol=@cache,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/cache
mount -t btrfs -o subvol=@tmp,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/tmp
mount -t btrfs -o subvol=@log,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/log
mount -t btrfs -o subvol=@docker,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/lib/docker
mount -t btrfs -o subvol=@libvirt,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/lib/libvirt
mount -t btrfs -o subvol=@home,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/home
