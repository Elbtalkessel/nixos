#!/usr/bin/env sh

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
    fi
    if [ "$ANSWER" = "n" ]; then
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
      break fi
  done
}

# Install home manager.
# See https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
# sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
# sudo nix-channel --update

echo "PARTITIONING"
DISK=$(prompt "Root drive? (lsblk):")
[ $(ask "Erase disk ${DISK}?") != "y" ] && exit 1
echo "Erasing $DISK"
sudo sgdis -og $DISK

echo "Creating boot partition"
sudo sgdisk -n 1::+1G -c 1:boot -t 1:ef00 $DISK

echo "Creating root partition"
sudo sgisk -n 2::0 -c 2:root -t 2:8309 $DISK


echo "ENCRYPTING"
PASSWD=$(prompt "Password?")
echo "Encrypting ${DISK}2"
echo -n $PASSWD | sudo cryptsetup --batch-mode luksFormat --label root "${DISK}2" -
sleep 5
echo "Open encrypted volumne to /dev/mapper/root"
echo -n $PASSWD | sudo cryptsetup open "${DISK}2" root -
sleep 5


echo "CREATING LVM GROUPS"
echo "Creating physical volume"
sudo pvcreate /dev/mapper/root
pvdisplay

echo "Create virtual volume"
sudo vgcreate vg /dev/mapper/root
sudo vgdisplay

SWAP_SIZE=$(prompt "Swap size?" "8G")
echo "Creating ${SWAP_SIZE} swap logical volume"
sudo lvcreate -n swap -L $SWAP_SIZE vg

echo "Creating root logical volume"
sudo lvcreate -n root -l +100%FREE vg


echo "CREATING FILESYSTEM"
echo "Formatting boot partition"
sudo mkfs.vfat -n boot "${DISK}1"

echo "Formatting and enabling swap partition"
sudo mkswap /dev/vg/swap
swapon /dev/vg/swap

echo "Formatting root partition"
sudo mkfs.btrfs -L root /dev/vg/root


echo "CREATING ROOT BTRFS LAYOUT"
echo "Creating subvolumes"
sudo mount -t btrfs /dev/vg/root /mnt
sudo btrfs su cr /mnt/@
sudo btrfs su cr /mnt/@nix
sudo btrfs su cr /mnt/@root
sudo btrfs su cr /mnt/@srv
sudo btrfs su cr /mnt/@cache
sudo btrfs su cr /mnt/@tmp
sudo btrfs su cr /mnt/@log
sudo btrfs su cr /mnt/@docker
sudo btrfs su cr /mnt/@libvirt
sudo btrfs su cr /mnt/@home

echo "Re-mounting with subvolumes"
sudo umount /mnt
BTRFS_MOUNT_OPT=defaults,ssd,noatime,compress=zstd

echo "Mounting root"
sudo mount -t btrfs -o subvol=@,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt
sudo mkdir -p /mnt/{boot,boot/efi,home,root,srv,var/cache,var/tmp,var/log,var/lib/docker,var/lib/libvirt}

echo "Disabling CoW"
sudo chattr -R +C /var/lib/docker
sudo chattr -R +C /var/lib/libvirt

echo "Mounting boot"
sudo mount /dev/disk/by-label/boot /mnt/boot/efi

echo "Mounting subvolumes"
sudo mount -t btrfs -o subvol=@nix,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/nix
sudo mount -t btrfs -o subvol=@root,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/root
sudo mount -t btrfs -o subvol=@srv,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/srv
sudo mount -t btrfs -o subvol=@cache,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/cache
sudo mount -t btrfs -o subvol=@tmp,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/tmp
sudo mount -t btrfs -o subvol=@log,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/log
sudo mount -t btrfs -o subvol=@docker,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/lib/docker
sudo mount -t btrfs -o subvol=@libvirt,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/var/lib/libvirt
sudo mount -t btrfs -o subvol=@home,${BTRFS_MOUNT_OPT} /dev/vg/root /mnt/home

echo "Generating config"
nixos-generate-config --root /mnt
