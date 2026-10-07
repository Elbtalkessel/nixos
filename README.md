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
hosts/<host>/secrets.yaml    # sops-encrypted file for that host (one per host)
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

From a NixOS live ISO, install any host in the repo (`omen`, `atlas`, `virt`,
...). The install steps are identical regardless of which host; what differs
is the substitution of `${host}` and the user assigned in
`hosts/<host>/config.nix`.

> **Run every `nix` invocation on the live ISO with `--experimental-features
> "nix-command flakes"`. The commands below include this flag.

### 1. Optional SSH into the live ISO

Public key:

```bash
mkdir -p .ssh
curl --follow codeberg.org/outlast.keys > .ssh/authorized_keys
chmod 700 -R .ssh
```

Password:

```bash
passwd
```

### 2. Clone the repo

```bash
git clone https://codeberg.org/outlast/nixos
cd nixos
```

### 3. Partition and install

Replace `<host>` with one of the host names from `flake.nix` (`hosts.<host>`),
and the `user` with the value `flake.nix` assigns to that host (currently
`risus`, `atlas`, `virt`).

```bash
host="<host>"
sudo nix --experimental-features "nix-command flakes" \
    run github:nix-community/disko/latest -- --mode disko \
    ./hosts/${host}/disko.nix
sudo nixos-install --root /mnt --flake .#${host} --impure --no-write-lock-file
```

### 4. Drop the host's age key (only when `flake.nix` lists `host.sops = true`)

If the host chooses sops in the flake, drop a pre-minted per-host age key at
`/mnt/etc/sops-nix/key.txt` before exiting the live ISO. The system tmpfiles
rule (`F /etc/sops-nix/key.txt 0640 root sops - - -`) re-applies the perms on
every boot, but the file must already be on disk for the first
`sops-install-secrets` to decrypt anything:

```bash
sudo install -d -m 0750 /mnt/etc/sops-nix
sudo install -m 0640 -o root -g sops \
    /path/to/<host>.age.key /mnt/etc/sops-nix/key.txt
```

### 5. Reboot and activate

```bash
reboot
# log in as the user from `flake.nix`'s hosts.<host>.user -- root password
# was set during `nixos-install` only if the host's disko or installer did so.
sudo nixos-rebuild switch --flake /path/to/nixos#<host>
# Then activate home-manager as the user:
home-manager switch --flake /path/to/nixos#<user>
```

Note: the home-manager image needs `home-manager` or `nix run
github:nix-community/home-manager/master` once, depending on how it was
installed. The first activation reads `/etc/sops-nix/key.txt` (the user is in
the `users` group, so the 0640 perms are readable without sudo).

## Secrets setup 🔐

Each host owns its encrypted set in `hosts/<host>/secrets.yaml`. The file is
encrypted to two age recipients: a **master** key (the admin machine, used to
edit), and a **host** key (used by the host itself for activation).

`.sops.yaml` at the repo root wires a `path_regex` for each host: any secret
under `hosts/<host>/secrets.yaml` is re-encrypted to that host's anchor.

### Admin machine: minting a per-host key and wiring it in

```bash
# On your admin machine, in the cloned repo:
host="<host>"

# Generate a fresh age keypair for the host. The private half never leaves
# the host's disk; only the public half lands in `.sops.yaml`.
nix shell nixpkgs#age -c age-keygen -o /tmp/${host}.age.key
pub=$(nix shell nixpkgs#age -c age-keygen -y /tmp/${host}.age.key)

# Add the public half under a new `<host>` anchor in `.sops.yaml`, plus a
# creation_rules entry that re-encrypts `hosts/<host>/secrets.yaml` to it.
# See `.sops.yaml` for the existing omen / atlas entries -- the same shape
# applies to any new host, with `&<host>` being the new anchor and `*master`
# being the admin's anchor so you can still edit the file later.
```

### Admin machine: editing a host's encrypted file

```bash
host="<host>"
nix shell nixpkgs#sops -c sops hosts/${host}/secrets.yaml
```

`*.yaml` decrypts to plaintext, you edit, on save sops re-encrypts to the
recipients listed in the matching `.sops.yaml` rule. Never commit plaintext
copies; `.sops.yaml`-aware editors (`sops` CLI, VS Code plugin) take care of
this.

If you need a `sops.secrets.<name>.neededForUsers = true` (or other
NixOS-system-only fields like `owner` / `uid`) on a password-style secret,
**gate the declaration behind a tree check**. `hosts/<host>/config.nix` gets
imported by both the NixOS system and the Home Manager entrypoint, and the
home-manager sops secret type rejects those options. See
`hosts/omen/config.nix` for the `isSystem = !(config ? home && config.home ?
homeDirectory)` pattern.

### Host install: dropping the key into `/etc/sops-nix/key.txt`

The host needs its private age key on disk before the first
`sops-install-secrets` runs. `flake.nix`'s `sopsShared` makes `sops` a
system group on each sops-enabled host and adds the host's user
(`hosts.<host>.user` in `flake.nix`) to it. The key lives at
`/etc/sops-nix/key.txt` with mode `0640`, owned by `root:sops`. The user's
membership in `sops` is what lets `home-manager switch` read it without
sudo. Out-of-band copy from the admin is the preferred bootstrap; see step
4 of the Quick start.

```bash
sudo install -d -m 0750 /etc/sops-nix
sudo install -m 0640 -o root -g sops /tmp/${host}.age.key /etc/sops-nix/key.txt
sudo reboot
```

The `F /etc/sops-nix/key.txt 0640 root sops - - -` rule baked into
`flake.nix`'s `sopsShared` re-applies these on every boot, so a manual `cp`
that landed 0600 gets corrected at the next activation. `sops.environment`
also exports `SOPS_AGE_KEY_FILE=/etc/sops-nix/key.txt` to the activation
script and to the systemd user service, so shell-driven `sops` reads work
without an additional `--age-key-file` flag.

Why a dedicated group and not `users`: `users` is the primary group of
every normal-user account, which means any future service running under a
non-sops account could read the key. The `sops` group is opt-in — only
the user we explicitly add (via `users.users.<name>.extraGroups`) gets
access.

### Hosts without secrets

`flake.nix` lists `host.sops = false` for hosts that read no encrypted
values. These skip the path_regex block in `.sops.yaml` and skip the
`/etc/sops-nix/key.txt` rule in the flake. Nothing module-side looks for the
file, so install a key or skip it on those hosts as you prefer.

### Hosts without secrets

`flake.nix` lists `host.sops = false` for hosts that read no encrypted
values. These skip the path_regex block in `.sops.yaml` and skip the
`/etc/sops-nix/key.txt` rule in the flake. Nothing module-side looks for the
file, so install a key or skip it on those hosts as you prefer.

## Tailscale 🌐

A host joins the tailnet only when its profile opts in with `my.tailscale`:

- declared in `options/system.nix` with `default = false`,
- flipped on in `hosts/<host>/config.nix`: `my.tailscale = true;`.

When enabled, `modules/system/core/networking/tailscale.nix` runs
`tailscale up -authkey …` on boot via the `tailscale-autoconnect` unit, reading
the key from the host's own `secrets.yaml` under `tailscale.one-of-key`. No
interactive login needed.

No Tailscale **API access token** is required — only an **auth key**
(`tskey-auth-…`), a device pre-authentication key.

### Generate, store, and rotate

1. Open the [Keys page of the admin console](https://login.tailscale.com/admin/settings/keys)
   (requires Owner, Admin, or Network admin).
2. **Generate auth key** with:
   - **Reusable**: recommended for an unattended machine. A one-off key is
     spent by the first authentication, so any re-auth (e.g. after node-key
     expiry) would fail.
   - **Expiry**: 1–90 days, defaults to 90. An expired key cannot
     authenticate new sessions; already-authorised devices keep working
     until their own node key expires.
   - **Tags** / **Pre-approved**: per your tailnet policy.
3. Copy the `tskey-auth-…` value (shown only once — it is as sensitive as a
   password).
4. **Store** on the admin machine:

   ```bash
   host="<host>"
   nix shell nixpkgs#sops -c sops hosts/${host}/secrets.yaml
   # Edit `tailscale.one-of-key` in the decrypted file; on save sops
   # re-encrypts to the host's recipients.
   ```

5. **Rotate**: generate a new key on the same Keys page, revoke the old one
   there, edit `tailscale.one-of-key` as above, rebuild the host.

### State check

On the host:

```bash
tailscale status                       # should report "Running"
systemctl status tailscale-autoconnect # last status of the boot-time auth
```

A failed `tailscale-autoconnect` with the backend stopped almost always means
the key expired or was revoked — rotate it.

## Roadmap 🧭

- USBGuard integration for better BadUSB protection on laptops and workstations.
- Declarative QEMU virtual machines (e.g. Ubuntu 20.04, Windows) defined directly in Nix.
- Show trash size.
- Show disk usage.
- Periodically remove trash (Maybe based on disk usage? Only if 70% left, remove trash for last 7 days? Or by size, 20% of disk?)
- Automatic home generation cleanup, always keep 5 latest.

## License 📜

This repository is published under the Unlicense, dedicating the content to the public domain.
