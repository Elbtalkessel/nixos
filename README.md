## `NixOS` system and home configuration files

### Deployment

> `disko-install` does not work for me when installing from a live USB

Instruction is for a virtual machine and for booting from a live USB.

```sh
# If you're using minimal installation, it will be easier to connection via ssh,
# grab machine's IP address:
virsh net-dhcp-leases
# set any password while you're inside virtual machine:
passwd
# open a terminal session, run
ssh nixos@192.168.122.121

# Partitioning
curl https://raw.githubusercontent.com/Elbtalkessel/nixos/refs/heads/deploy/hw/virt-disko.nix -o virt-disko.nix
# Set encryption password
echo -n "password" | sudo tee /tmp/secret.key
# Partition the selected device. It will wipe /dev/vda (or any other device in the virt-disko.nix)
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko virt-disko.nix

# Installation
sudo nixos-install -v --root /mnt --flake github:Elbtalkessel/nixos/deploy#virt --impure --no-write-lock-file

# Reboot

home-manager switch --flake github:Elbtalkessel/nixos/deploy#omen
```

## To do

- home/bin/screenshot.sh: read session variables instead of hard-coded values.
- add [USB Guard](https://usbguard.github.io/)
- setup system auto upgrade
- setup home manager auto upgrade
- Flatpak declarative app install and app permissions
- Qemu declarative machine definition (ubuntu 20.04, windows)
- integrate [sops-nix](https://github.com/Mic92/sops-nix?tab=readme-ov-file#Flakes)
  - add GitHub access token to it, https://github.com/NixOS/nix/issues/6536#issuecomment-1254858889 and https://nix.dev/manual/nix/2.18/command-ref/conf-file#file-format
  - add samba creds, /root/secrets/samba
  - add wg creds, /root/secrets/wg/wg0.conf
  - add optimizer license key
- replace hardcode paths in environment.nix and ide.nix
