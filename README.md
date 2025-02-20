## `NixOS` system and home configuration files

### Layout

- flake.nix:
  - ./home: home-manager modules
  - ./hosts: machine specific configuration
  - ./system: shared machine configuration
  - ./packages: some 3rd party binaries packaged for nix

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
# Note: nix caches flakes, if you change it, use commit hash to re-download latest changes:
# `git log --oneline | head -1 | awk '{print $1}' | xargs git rev-parse` instead of `deploy`.
sudo nixos-install -v --root /mnt --flake github:Elbtalkessel/nixos/deploy#virt --impure --no-write-lock-file

# Reboot, it will briefly complain about hyprland and kick to greeter, change tty, login as root,
# set user password, logout and login as a regular user
# FIXME: workaround:
rm -r .config/fish
# install...
home-manager switch --flake github:Elbtalkessel/nixos/deploy#risus --no-write-lock-file
```

### Setup secrets

```sh
mkdir -p sops/age
nix shell "nixpkgs#age" -c age-keygen -o ~/.config/sops/age/keys.txt
nix run "nixpkgs#ssh-to-age" -- -private-key -i ~/.ssh/id_ed25519 >! ~/.config/sops/age/keys.txt
# Open .sops.yaml and follow instruction
```

## To do

- `home/bin/screenshot.sh`: read session variables instead of hard-coded values.
- Add [USB Guard](https://usbguard.github.io/)
- Qemu declarative machine definition (ubuntu 20.04, windows)
- Add GitHub access token to secrets, https://github.com/NixOS/nix/issues/6536#issuecomment-1254858889 and https://nix.dev/manual/nix/2.18/command-ref/conf-file#file-format
- Waybar doesn't start, hyprland `exce-once` doesn't always work, systemd service never works, maybe a slight delay will help?
