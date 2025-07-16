# `NixOS` system and home configuration files

## Deployment

_`disko-install` does not work for me when installing from a live USB_

Instruction is for a virtual machine and for booting from a live USB.

```sh
# If you're using nixos minimal installation image, it will be easier to connection via ssh:
# - Grab machine's IP address:
virsh net-dhcp-leases
# - Set any password while you're inside virtual machine:
passwd
# Open a terminal session on host:
ssh nixos@192.168.122.121

# Preparing disks.
# Download layout:
curl https://raw.githubusercontent.com/Elbtalkessel/nixos/refs/heads/main/system/disko/virt.nix -o virt-disko.nix
# Set a password for the main partition:
echo -n "<password>" | sudo tee /tmp/secret.key
# The following command will format /dev/vda (check virt-disko.nix content):
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko virt-disko.nix

# OS Configuration.
# Note: nix caches flakes, if you change it, use commit hash to
# download the latest changes:
# `git log --oneline | head -1 | awk '{print $1}' | xargs git rev-parse` instead of `deploy`.
sudo nixos-install -v --root /mnt --flake github:Elbtalkessel/nixos/main#virt --impure --no-write-lock-file

# Home Configuration
home-manager switch --flake github:Elbtalkessel/nixos/main#risus --no-write-lock-file
```

### Setup secrets

```sh
mkdir -p sops/age
nix shell "nixpkgs#age" -c age-keygen -o ~/.config/sops/age/keys.txt
nix run "nixpkgs#ssh-to-age" -- -private-key -i ~/.ssh/id_ed25519 >! ~/.config/sops/age/keys.txt
# Open .sops.yaml and follow instruction
```

## To do

- Add [USB Guard](https://usbguard.github.io/)
- Qemu declarative machine definition (ubuntu 20.04, windows)
