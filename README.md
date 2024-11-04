## NixOS system and home configuration files

### Deployment

Two-steps process, first download and adjust disko.nix configuration,
then use nixos-install to install onto newly created partition.
The disko-install utility tries to download everything at once and hits disk space limit
when you install from a live usb.

```sh
curl https://raw.githubusercontent.com/Elbtalkessel/nixos/deploy/config/disko.nix -o disko.nix
# Adjust value of disk.main.device
vim disko.nix
# Set encryption password
echo -n "password" | sudo tee /tmp/secret.key
# Partition the selected device
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko disko.nix
# Install
sudo nixos-install -v --root /mnt --flake github:Elbtalkessel/nixos/deploy/config#omen --impure
```

## To do

- home/bin/screenshot.sh: read session variables instead of hard-coded values.
- add [USB Guard](https://usbguard.github.io/)
- setup system auto upgrade
- setup home manager auto upgrade
- flatpak declarative app install and app permissions
- qemu declarative machine definition (ubuntu 20.04, windows)
- cleanup setup scripts, use [disko](https://github.com/nix-community/disko)
- integrate [sops-nix](https://github.com/Mic92/sops-nix?tab=readme-ov-file#Flakes)
  - add github access token to it, https://github.com/NixOS/nix/issues/6536#issuecomment-1254858889 and https://nix.dev/manual/nix/2.18/command-ref/conf-file#file-format
  - add samba creds, /root/secrets/samba
  - add wg creds, /root/secrets/wg/wg0.conf
  - add optimizer license key
- replace hardcode paths in environment.nix and ide.nix
