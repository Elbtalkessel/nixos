# 🍞 NixOS Configuration

[bread] Home / NixOS / Configuration [/bread]

# NixOS Configuration ❄️

Personal NixOS and Home Manager configuration, wired for reproducible installs, disk partitioning with `disko`, and secret management via `sops-nix` and age keys.

## Features ✨

- Flake-based NixOS and Home Manager configs for multiple hosts and users.
- Disk layout and filesystem provisioning via `disko` (including encrypted root setups).
- Secret management using `sops` and age keys for machine and user secrets.
- Two hosts: `omen` (a laptop) and `virt`, a deliberately barebones example host that shares no modules with `omen`.

## Repository layout 🗂️

Modules are organised in three buckets. The buckets are **purely organisational** — they carry no behaviour and no configuration of their own. Custom options stay under `my.*` in `options/`.

`options/` is split by **role first, then by domain**, rather than by bucket. Buckets describe *behaviour* and are selected per host; `my.*` settings are consumed by both trees at once, so every configuration imports the whole namespace and bucketing it would buy no selectivity. Roles are kept apart because they change for different reasons and are read by different people: `options/options/` is the reference you consult when using a setting and changes rarely, `options/config/` is the profile you edit when changing the machine. The same filename appears on both sides — `my.mail` is declared in `options/options/mail.nix` and set in `options/config/mail.nix`.

| Bucket | Holds |
| --- | --- |
| `core` | Host- and user-agnostic infrastructure: identity, secrets, shell, tools, packages, networking, storage, locale, diagnostics. |
| `desktop` | The desktop experience: session, panel, launchers, notifications, wallpaper. |
| `apps` | End-user applications: browser, mail, media, terminals, files, IDE, image viewer, LLM clients. |

```
flake.nix              # inputs, shared sops defaults, host entrypoint wiring
options/               # my.* settings (shared by both trees)
  options/             #   mkOption declarations -- the reference
    my.nix             #   the single `my` namespace declaration
    <domain>.nix       #   one file per domain: identity, mail, theme, ...
  config/              #   config.my.* values -- this machine's profile
    common.nix         #   shared values (not a module)
    <domain>.nix       #   matching filename on both sides
hosts/<host>/
  nixos.nix            # host entrypoint: hostName, platform, stateVersion, imports
  home.nix             # home entrypoint for that host
  disko.nix            # disk layout for that host
home/
  environment.nix      # session-wide environment
  modules/{core,desktop,apps}/
system/
  modules/{core,desktop}/
secrets/               # sops-encrypted files
```

### Placement rules

1. **No upward references.** A module may only reference files inside its own directory or explicit shared roots (`home/modules`, `system/modules`). It must never reach up to the repo root or sideways into another host.
2. **Assets are colocated.** Non-Nix files a module needs (`.vimrc`, `.conf`, patches, assets) live next to the module that uses them.
3. **`default.nix` is a barrel when siblings exist.** A directory that aggregates sibling modules keeps its `default.nix` limited to `imports`. A directory holding a single module may use `default.nix` as that module.
4. **Host-specific settings live in `hosts/`.** `hostName`, `stateVersion`, `hostPlatform` and disk layouts belong to a host entrypoint, never to a shared `core` module.
5. **A setting's declaration and its value share a filename.** `my.<domain>` is declared in `options/options/<domain>.nix` and set in `options/config/<domain>.nix`. Adding a setting means touching both sides; the matching name is how you find them.
6. **`options/my.nix` declares `my` once, empty.** Domain files extend it as `options.my = { ... };`. Never give it a populated `submodule { options = ...; }` — that form is closed and would reject the domain files' declarations.
7. **`bin/` is unmanaged.** Scripts there are not part of the module tree.

## Quick start (live ISO) 🚀

From a NixOS live ISO, set a password and connect via SSH, then prepare the disk and install:

```bash
# Set a temporary password
passwd

# Prepare disk layout (will format the omen root disk)
curl https://raw.githubusercontent.com/Elbtalkessel/nixos/refs/heads/main/hosts/omen/disko.nix -o omen-disko.nix
echo -n "<password>" | sudo tee /tmp/secret.key
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko omen-disko.nix

# Install NixOS from this flake
sudo nixos-install -v --root /mnt --flake github:Elbtalkessel/nixos/main#omen --impure --no-write-lock-file
```

> **Note:** this installs the `omen` profile, whose disk layout targets `/dev/nvme0n1`.
> For a virtual machine, use the `virt` profile instead — its layout targets `/dev/vda`:
>
> ```bash
> curl https://raw.githubusercontent.com/Elbtalkessel/nixos/refs/heads/main/hosts/virt/disko.nix -o virt-disko.nix
> echo -n "<password>" | sudo tee /tmp/secret.key
> sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko virt-disko.nix
> sudo nixos-install -v --root /mnt --flake github:Elbtalkessel/nixos/main#virt --impure --no-write-lock-file
> ```
>
> `virt` exists as a worked example of how a host entrypoint composes a
> configuration. It imports nothing from `system/modules/`, because those modules
> are written against `omen`'s hardware — see `hosts/virt/nixos.nix`.

After reboot, log into the system and activate the Home Manager configuration:

```bash
home-manager switch --flake github:Elbtalkessel/nixos/main#risus --no-write-lock-file
```

Use `home-manager switch --flake github:Elbtalkessel/nixos/main#virt` on the VM;
`homeConfigurations.virt` carries only the shell, git and file-manager slice.

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
- Show trash size.
- Show disk usage.
- Periodically remove trash (Maybe based on disk usage? Only if 70% left, remove trash for last 7 days? Or by size, 20% of disk?)
- Automatic home generation cleanup, always keep 5 latest.

## License 📜

This repository is published under the Unlicense, dedicating the content to the public domain.
