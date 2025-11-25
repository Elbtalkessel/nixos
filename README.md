# 🍞 NixOS Configuration

[bread] Home / NixOS / Configuration [/bread]

# NixOS Configuration ❄️

Personal NixOS and Home Manager configuration, wired for reproducible installs, disk partitioning with `disko`, and secret management via `sops-nix` and age keys.

## Features ✨

- Flake-based NixOS and Home Manager configs for multiple hosts and users.
- Disk layout and filesystem provisioning via `disko` (including encrypted root setups).
- Secret management using `sops` and age keys for machine and user secrets.
- Ready-to-use virtual machine profile (`virt`) for quick testing and development.

## Quick start (VM / live ISO) 🚀

From a NixOS live ISO or virtual machine, set a password and connect via SSH, then prepare the disk and install:

```bash
# Set a temporary password in the VM
passwd

# Prepare disk layout (will format /dev/vda)
curl https://raw.githubusercontent.com/Elbtalkessel/nixos/refs/heads/main/system/disko/virt.nix -o virt-disko.nix
echo -n "<password>" | sudo tee /tmp/secret.key
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko virt-disko.nix

# Install NixOS from this flake
sudo nixos-install -v --root /mnt --flake github:Elbtalkessel/nixos/main#virt --impure --no-write-lock-file
```

After reboot, log into the system and activate the Home Manager configuration:

```bash
home-manager switch --flake github:Elbtalkessel/nixos/main#risus --no-write-lock-file
```

## Secrets setup 🔐

This configuration expects secrets to be managed with `sops` and age keys:

```bash
mkdir -p ~/.config/sops/age
nix shell "nixpkgs#age" -c age-keygen -o ~/.config/sops/age/keys.txt
nix run "nixpkgs#ssh-to-age" -- -private-key -i ~/.ssh/id_ed25519 >! ~/.config/sops/age/keys.txt
```

Then update `.sops.yaml` at the repo root to wire hosts, files, and key references.

## Roadmap 🧭

- USBGuard integration for better BadUSB protection on laptops and workstations.
- Declarative QEMU virtual machines (e.g. Ubuntu 20.04, Windows) defined directly in Nix.

## License 📜

This repository is published under the Unlicense, dedicating the content to the public domain.
