#!/usr/bin/env sh

source ./shell/common.sh
justHelp $1 "Deploys luks on lvm NixOS on a blank drive."
asRoot

# Initial NixOS setup.
# Inspired by:
# https://blog.kolaente.de/2021/11/installing-nixos-with-encrypted-btrfs-root-device-and-home-manager-from-start-to-finish/
# https://discourse.nixos.org/t/newbie-needs-help-systemd-boot-luks-lvm-btrfs-howto/28294/5

[ $(ask "The script is dumb and cannot handle nothing but already blank, non-mounted drive. Please read the script first. THE SCRIPT WILL ERASE SELECTED DISK! Continue?") != "y" ] && exit 1

BOOT_PART_LABEL="boot"
ROOT_PART_LABEL="root"
IS_LEGACY_BOOT=$(ask "Is it legacy boot?")

echo "PARTITIONING"
DISK=$(prompt "Root drive? (lsblk):")
echo "Erasing $DISK"
sgdisk -og $DISK

echo "Creating boot partition"
if [ $IS_LEGACY_BOOT = "y" ];
then
  sgdisk -n 1::+5M -c 1:${BOOT_PART_LABEL} -t 1:ef00 ${DISK}
else
  sgdisk -n 1::+1G -c 1:${BOOT_PART_LABEL} -t 1:ef00 ${DISK}
fi

echo "Creating root partition"
sgdisk -n 2::0 -c 2:${ROOT_PART_LABEL} -t 2:8309 $DISK


echo "ENCRYPTING"
PASSWD=$(prompt "Password?")
echo "Encrypting ${DISK}2"
echo -n $PASSWD | cryptsetup --batch-mode luksFormat --label ${ROOT_PART_LABEL} "${DISK}2" -
sleep 5
echo "Open encrypted volume to /dev/mapper/${ROOT_PART_LABEL}"
echo -n $PASSWD | cryptsetup open "${DISK}2" ${ROOT_PART_LABEL} -
sleep 5


echo "CREATING LVM GROUPS"
echo "Creating physical volume"
pvcreate /dev/mapper/${ROOT_PART_LABEL}
pvdisplay

echo "Create virtual volume"
vgcreate vg /dev/mapper/${ROOT_PART_LABEL}
vgdisplay

SWAP_SIZE=$(prompt "Swap size?" "8G")
echo "Creating ${SWAP_SIZE} swap logical volume"
lvcreate -n swap -L $SWAP_SIZE vg

echo "Creating root logical volume"
lvcreate -n ${ROOT_PART_LABEL} -l +100%FREE vg


echo "CREATING FILESYSTEM"
echo "Formatting boot partition"
mkfs.vfat -n ${BOOT_PART_LABEL} "${DISK}1"

echo "Formatting and enabling swap partition"
mkswap /dev/vg/swap
swapon /dev/vg/swap

echo "Formatting root partition"
mkfs.btrfs -L root /dev/vg/${ROOT_PART_LABEL}


echo "CREATING ROOT BTRFS LAYOUT"
echo "Creating subvolumes"
mount -t btrfs /dev/vg/${ROOT_PART_LABEL} /mnt
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
if [ ${IS_LEGACY_BOOT} = "n" ]; then
  source ./shell/mount.sh -b /dev/disk/by-label/${BOOT_PART_LABEL}
else
  source ./shell/mount.sh
fi

echo "Disabling CoW"
chattr -R +C /mnt/var/lib/docker
chattr -R +C /mnt/var/lib/libvirt

echo "Generate config"
nixos-generate-config --root /mnt
echo "Copy hardware configuration"
cp /mnt/etc/nixos/hardware-configuration.nix nixos/
echo "Please setup your root partition UUID in ./nixos/hardware-configuration.nix:"
ROOT_UUID=$(blkid "${DISK}2" | grep -E '[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}' -o)
cat <<EOF
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/${ROOT_UUID}";
      preLVM = true;
      allowDiscards = true;
    };
  };
EOF
if [ $IS_LEGACY_BOOT = "y" ]; then
  echo "  boot.loader.grub.device = \"${DISK}\";"
fi
echo "After you finish, run sudo ./cli.sh -sy -t /mnt/etc/nixos/ and run sudo ./cli.sh -i."
echo "Don't forget edit configuration.nix as well, choice bootloader and host name."
