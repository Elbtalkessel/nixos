# 🍞 NixOS Configuration

[bread] Home / NixOS / Configuration [/bread]

# NixOS Configuration ❄️

Personal NixOS and Home Manager configuration, wired for reproducible installs, disk partitioning with `disko`, and secret management via `sops-nix` and age keys.

## Features ✨

- Flake-based NixOS and Home Manager configs for multiple hosts and users.
- Disk layout and filesystem provisioning via `disko` (including encrypted root setups).
- Secret management using `sops` and age keys for machine and user secrets.
- Optional Tailscale mesh VPN, enabled per host and keyed through `sops`.

## Repository layout 🗂️

Modules are organised in three buckets. The buckets are **purely organisational** — they carry no behaviour and no configuration of their own. Custom options live under `my.*` in `options/`, declarations only; per-host values go in `hosts/<host>/config.nix`.

The `my.*` namespace is split **by domain**, not by tree: every option is declared once and is available to both trees at once. Adding a setting means touching `options/<domain>.nix`. Each host then opts in to the slice it needs from its own `config.nix` — `my.username` and `my.shell` are required; everything else is opt-in and a host that doesn't import a reader module never has to set the option.

| Bucket    | Holds                                                                                                                        |
| --------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `core`    | Host- and user-agnostic infrastructure: identity, secrets, shell, tools, packages, networking, storage, locale, diagnostics. |
| `desktop` | The desktop experience: session, panel, launchers, notifications, wallpaper.                                                 |
| `apps`    | End-user applications: browser, mail, media, terminals, files, IDE, image viewer, LLM clients.                               |

```
flake.nix              # inputs, shared sops defaults, host entrypoint wiring
options/               # my.* declarations (shared by both trees)
  my.nix               #   the single `my` namespace declaration
  default.nix          #   barrel: imports below
  <domain>.nix         #   one file per domain: identity, mail, theme, ...
hosts/<host>/
  nixos.nix            # NixOS entrypoint: hostName, platform, stateVersion, imports
  home.nix             # Home Manager entrypoint
  config.nix           # this host's `my.*` values, imported by both entrypoints
  disko.nix            # disk layout for that host
  <feature>/           # host-local module, with its assets next to it
                        # (atlas/opencode/ holds opencode.jsonc and omo.jsonc)
modules/               # the module tree, split by tree then bucket
  common/              #   imported by *both* trees -- overlays only
    nixpkgs.nix        #     nixpkgs-custom, nuenv, nixvim overlays
  home/                # home-manager modules
    core/              #   identity, secrets, shell, tools, xdg, environment, ...
    desktop/           #   session, panel, launchers, notifications, wallpaper
    apps/              #   browser, mail, media, terminals, files, IDE, ...
  system/              # NixOS modules
    core/              #   networking, storage, users, fonts, audio, boot, ...
    desktop/           #   session
    apps/              #   steam
secrets/               # sops-encrypted files
```

### Placement rules

1. **No upward references.** A module may only reference files inside its own directory or explicit shared roots (`modules/common`, `modules/home`, `modules/system`). It must never reach up to the repo root or sideways into another host.
2. **Assets are colocated.** Non-Nix files a module needs (`.vimrc`, `.conf`, patches, assets) live next to the module that uses them.
3. **`default.nix` is a barrel when siblings exist.** A directory that aggregates sibling modules keeps its `default.nix` limited to `imports`. A directory holding a single module may use `default.nix` as that module.
4. **Host-specific settings live in `hosts/`.** `hostName`, `stateVersion`, `hostPlatform`, disk layouts and anything that differs per machine (a provider address, a login shell) belong to a host entrypoint or a host-local module, never to a shared `core` module. A per-host `my.*` profile lives in `hosts/<host>/config.nix` and is imported from both `nixos.nix` and `home.nix` — see `hosts/atlas/opencode/` for a host-local module example.
5. **`options/<domain>.nix` declares the whole `my.<domain>` slice.** Adding a setting is a one-file change: declare the leaf in the domain file, set its value in the relevant `hosts/<host>/config.nix`.
6. **`options/my.nix` declares `my` once, empty.** Domain files extend it as `options.my = { ... };`. Never give it a populated `submodule { options = ...; }` — that form is closed and would reject the domain files' declarations.
7. **A `submodule` option needs no `default`.** It is populated from its children's defaults, transitively. Writing `default = { };` on one is a no-op: it does not cascade, and a child with no `default` and no `config` value still throws. Give the _leaf_ a `default`, or set it in the relevant `hosts/<host>/config.nix`.
8. **`bin/` is unmanaged.** Scripts there are not part of the module tree.
9. **`modules/common/` is for `nixpkgs` wiring only, and `modules/common/nixpkgs.nix` is the only module in it.** Anything both trees need from the package set — an overlay — is declared there as `nixpkgs.overlays`, because both `nixosSystem` and `homeManagerConfiguration` read that option. Anything *not* shared stays in the tree that uses it.
10. **Unfree permission is declared by the module that wants the package.** Set `nixpkgs.config.allowUnfreePackages = [ ... ];` locally in the importing module rather than collecting names centrally: the option merges additively down the tree, so a module that installs an unfree package is the only place that has to know its name. Do not pass a pre-built package set to `nixpkgs.pkgs` to achieve it — a tree given `nixpkgs.pkgs` ignores `nixpkgs.overlays` and `nixpkgs.config` entirely.

## Quick start 🚀

From a NixOS live ISO, set a password and connect via SSH, then prepare the disk and install.

> **Note:** Running flakes requires enabling experimental features. The commands below include `--experimental-features "nix-command flakes"` as needed.

### Optional ssh connection

Using public key:

```bash
mkdir .ssh/
curl --follow codeberg.org/outlast.keys > .ssh/authorized_keys
chmod 700 -R .ssh
```

Using password:

```bash
passwd
```

```bash
git clone https://codeberg.org/outlast/nixos
host="..."
cd nixos
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./hosts/${host}/disko.nix
sudo nixos-install -v --root /mnt --flake .#${host} --impure --no-write-lock-file
```

After reboot, log into the system and activate the Home Manager configuration,
substituting the host you installed:

```bash
nix --experimental-features "nix-command flakes" run home-manager/master -- switch --flake git+https://codeberg.org/outlast/nixos#risus --no-write-lock-file
```

## Secrets setup 🔐

This configuration expects secrets to be managed with `sops` and age keys:

```bash
mkdir -p ~/.config/sops/age
alias nix='nix --experimental-features "nix-command flakes"'
nix shell "nixpkgs#age" -c age-keygen -o ~/.config/sops/age/keys.txt
nix run "nixpkgs#ssh-to-age" -- -private-key -i ~/.ssh/id_ed25519 >! ~/.config/sops/age/keys.txt
```

Then update `.sops.yaml` at the repo root to wire hosts, files, and key references.

## Tailscale 🌐

A host joins the tailnet only when its profile opts in with `my.tailscale`:

- declared in `options/system.nix` with `default = false`,
- flipped on in the relevant `hosts/<host>/config.nix` — currently only `hosts/omen/config.nix`.

When enabled, `modules/system/core/networking/tailscale.nix` runs
`tailscale up -authkey …` on boot via the `tailscale-autoconnect` unit, reading
the key from the `tailscale/one-of-key` sops secret, so the machine never needs
an interactive login. Firewall holes (the `tailscale0` interface and the
WireGuard UDP port) are opened by `modules/system/core/networking/security.nix`
on the same condition.

No Tailscale **API access token** is required — only an **auth key**
(`tskey-auth-…`), which is a device pre-authentication key.

### Generating an auth key

1. Open the [Keys page of the admin console](https://login.tailscale.com/admin/settings/keys)
   (requires Owner, Admin, or Network admin).
2. Select **Generate auth key**.
3. Fill the form:
   - **Reusable**: recommended for an unattended machine. A one-off key is
     spent by the first authentication, so a later re-auth (for example after
     the node key expires) would fail.
   - **Expiry**: 1–90 days, defaults to 90. An expired key cannot
     authenticate new sessions; already-authorized devices keep working until
     their own node key expires.
   - **Tags** / **Pre-approved**: optional, depending on your tailnet policy.
4. Select **Generate key** and copy the `tskey-auth-…` value. It is shown only
   once.

### Storing the key

The key lives encrypted in `secrets/secrets.yaml` under `tailscale.one-of-key`,
encrypted for the age recipient listed in `.sops.yaml`:

```bash
nix-shell -p sops --run "sops secrets/secrets.yaml"
```

Edit `tailscale.one-of-key`, save, and sops re-encrypts the file on exit.
Never store the key in plaintext — it is as sensitive as a password.

### Rotating or troubleshooting

- **Rotate**: generate a fresh key on the same Keys page, revoke the old one
  there, update `tailscale.one-of-key`, and rebuild the host.
- **Check state on the host**: `tailscale status` (should report `Running`)
  and `systemctl status tailscale-autoconnect`.
- A failed autoconnect with the backend stopped usually means the key
  expired or was revoked — rotate it as above.

## Roadmap 🧭

- USBGuard integration for better BadUSB protection on laptops and workstations.
- Declarative QEMU virtual machines (e.g. Ubuntu 20.04, Windows) defined directly in Nix.
- Show trash size.
- Show disk usage.
- Periodically remove trash (Maybe based on disk usage? Only if 70% left, remove trash for last 7 days? Or by size, 20% of disk?)
- Automatic home generation cleanup, always keep 5 latest.

## License 📜

This repository is published under the Unlicense, dedicating the content to the public domain.
