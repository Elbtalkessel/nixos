#!/usr/bin/env sh

set -e

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  echo "Not running as root"
  exit
fi


# Initial NixOS setup.
# Inspired by:
# https://blog.kolaente.de/2021/11/installing-nixos-with-encrypted-btrfs-root-device-and-home-manager-from-start-to-finish/
# https://discourse.nixos.org/t/newbie-needs-help-systemd-boot-luks-lvm-btrfs-howto/28294/5

# Utility functions
# EXAMPLE:
#   [ "$(ask "Close?" = "y" ] && exit 0
ask() {
  printf >&2 "%s (y/n): " "$1"
  while true; do
    read -r ANSWER
    if [ "$ANSWER" = "y" ]; then
      echo "y"
      break
    elif [ "$ANSWER" = "n" ]; then
      echo "n"
      break
    fi
  done
}

# EXAMPLE:
#   Compulsory prompt
#     COOKIES=$(prompt "Cookies?")
#   Optional prompt, second argument is default value
#     COOKIES=$(prompt "Cookies?" "YES")
prompt() {
  QUESTION=$1
  DEFAULT_VALUE=$2
  while true; do
    printf >&2 "%s (%s) " "$QUESTION" "${DEFAULT_VALUE:-required}"
    read -r ANSWER
    ANSWER=${ANSWER:-$DEFAULT_VALUE}
    if [ "$ANSWER" != "" ]; then
      echo >&2 ""
      echo "$ANSWER"
      break
    fi
  done
}

# Install home manager.
# See https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
# nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
# nix-channel --update

echo "PARTITIONING"
DISK=$(prompt "Root drive? (lsblk):")
[ $(ask "Erase disk ${DISK}?") != "y" ] && exit 1
echo "Erasing $DISK"
sgdisk -og $DISK

echo "Creating boot partition"
sgdisk -n 1::+1G -c 1:boot -t 1:ef00 $DISK

echo "Creating root partition"
sgdisk -n 2::0 -c 2:root -t 2:8309 $DISK


echo "ENCRYPTING"
PASSWD=$(prompt "Password?")
echo "Encrypting ${DISK}2"
echo -n $PASSWD | cryptsetup --batch-mode luksFormat --label root "${DISK}2" -
sleep 5
echo "Open encrypted volumne to /dev/mapper/root"
echo -n $PASSWD | cryptsetup open "${DISK}2" root -
sleep 5


echo "CREATING LVM GROUPS"
echo "Creating physical volume"
pvcreate /dev/mapper/root
pvdisplay

echo "Create virtual volume"
vgcreate vg /dev/mapper/root
vgdisplay

SWAP_SIZE=$(prompt "Swap size?" "8G")
echo "Creating ${SWAP_SIZE} swap logical volume"
lvcreate -n swap -L $SWAP_SIZE vg

echo "Creating root logical volume"
lvcreate -n root -l +100%FREE vg


echo "CREATING FILESYSTEM"
echo "Formatting boot partition"
mkfs.vfat -n boot "${DISK}1"

echo "Formatting and enabling swap partition"
mkswap /dev/vg/swap
swapon /dev/vg/swap

echo "Formatting root partition"
mkfs.btrfs -L root /dev/vg/root


echo "CREATING ROOT BTRFS LAYOUT"
echo "Creating subvolumes"
mount -t btrfs /dev/vg/root /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@nix
btrfs su cr /mnt/@root
btrfs su cr /mnt/@srv
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@log
btrfs su cr /mnt/@docker
btrfs su cr /mnt/@libvirt
btrfs su cr /mnt/@home

echo "Re-mounting with subvolumes"
umount /mnt
BTRFS_MOUNT_OPT=defaults,ssd,noatime,compress=zstd

echo "Mounting root"
mount -t btrfs -o subvol=@,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt
mkdir -p /mnt/{boot,boot/efi,home,root,srv,var/cache,var/tmp,var/log,var/lib/docker,var/lib/libvirt}

echo "Disabling CoW"
chattr -R +C /var/lib/docker
chattr -R +C /var/lib/libvirt

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

