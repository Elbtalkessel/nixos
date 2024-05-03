#!/usr/bin/env sh

source ./shell/common.sh

while [[ $# -gt 0 ]]; do
  case $1 in
    -b|--boot)
      BOOT_PART=$2;
      shift
      shift
      ;;
    *)
      echo "Mounts a partition with label 'boot' to /mnt/boot/efi and /dev/vg/root parition with subvolumes to /mnt"
      echo "Note: before mounting you need to setup partitions with setup script."
      echo "Note: partition has to be decrypted - use 'cryptsetup open /dev/sdX root' to do so."
      echo "Note: decrypted partion has to be mapped to /dev/mapper/root."

      echo "  -b /dev/sdXX, --boot /dev/sdXX     if set, specified partition will be mounted at /mnt/boot"
      exit 0
      ;;
  esac
done

asRoot

BTRFS_MOUNT_OPT=defaults,ssd,noatime,compress=zstd

echo "Mounting root"
mount -t btrfs -o subvol=@,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt

echo "Creating mount points"
mkdir -p /mnt/{home,root,srv,nix,var/cache,var/tmp,var/log,var/lib/docker,var/lib/libvirt}

if [ ${BOOT_PART} ]; then
  echo "Mounting boot"
  mkdir -p /mnt/boot/efi
  mount /dev/disk/by-label/boot /mnt/boot/efi
fi

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
