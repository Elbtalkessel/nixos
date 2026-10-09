# NixOS Configuration

- [What is it?](#what-is-it)
- [Key features](#key-features)
- [Adding a new host](#adding-a-new-host)
- [Deploying a host](#deploying-a-host)
- [Repository walkthrough](#repository-walkthrough)

## What is it?

A flake-based NixOS and Home Manager configuration that builds, per host, both the system tree and the user tree from a single source.

## Key features

- One `flake.nix` declares every host; rebuilding produces the system and user configuration for any of them.
- `disko` provisions disks per host; one layout file per host.
- Per-host encrypted secrets file with a per-host age key; admin and host keep working copies independently.
- A single shared `my.*` namespace, declared once in `options/` and consumed by both trees.

## Adding a new host

A new host is four edits and one runtime step.

```nix
# 1. Register the host in flake.nix's `hosts` attrset.
hosts.<name> = {
  dir = ./hosts/<name>;
  user = "<user>";
  sops = <true | false>;
};
```

> `sops = true` means the host's `hosts/<name>/secrets.yaml` exists and gets decrypted at activation. `sops = false` means every per-host secret declaration should be absent from `hosts/<name>/config.nix`. The default for new hosts is `true`.

```bash
# 2. Create the host directory and copy the four files from an existing host.
mkdir hosts/<name>
cp hosts/omen/{nixos,home,config,disko}.nix hosts/<name>/
```

> Edit `nixos.nix`'s `networking.hostName`, `stateVersion`, and module imports; `disko.nix`'s layout; `home.nix`'s `stateVersion` and module imports; `config.nix`'s `my.username`, `my.*` values, and `sops.secrets` list.

```bash
# 3. Mint a per-host age key on the admin workstation. <name> is hostname!
# Don't loose it, you need it for deploying a machine!
nix shell github:NixOS/nixpkgs/nixos-unstable#age -c age-keygen -o /tmp/<name>.age.key
# 3a. Create a password and copy it to the clipboard.
echo "password" | mkpasswd -s | wl-copy
# 3b. Open the host's, populate it with:
# users:
#   <name>: <paste>
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops hosts/<name>/secrets.yaml
```

> The private half never enters the repo. Paste the public half into `.sops.yaml` under a new `&<name>` anchor:

```yaml
# .sops.yaml addition
keys:
  - &primary age1<master-pub>
  - &<name> age1<host-pub>
creation_rules:
  - path_regex: hosts/<name>/secrets\.yaml$
    key_groups:
      - age:
          - *primary
          - *<name>
```

```bash
# 3.a Re-encrypt to the recipients currently listed in .sops.yaml.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops updatekeys hosts/<name>/secrets.yaml
```

> `flake.nix`'s `sopsShared` already creates the `sops` group, places the host user into it, and adds a `z` tmpfiles rule that keeps `/etc/sops-nix/key.txt` perm-locked at `0640 root:sops` on every boot (no content touch). The operator action is one `install` command at install time; see "Deploying a host" for the exact invocation.

## Deploying a host

A new machine starts at the NixOS live ISO. The whole install happens at the console; SSH is left for after the first boot.

```bash
# 1. Target console: Boot the ISO. Set a root password for the live session.
passwd
hostname -I

# 2. Main machine: copy pre-minted key.
scp /tmp/<name>.age.key nixos@<ip>:/tmp/

# 3. Target console: prepare sops for installation.
# Key should exist before installation, however we'll use
# `users` group for now, `sops` group unavailable at the moment.
sudo mkdir -p /mnt/etc/sops-nix
sudo install -m 0640 -o root -g users /tmp/<name>.age.key /mnt/etc/sops-nix/key.txt

# 4. Clone the repo.
git clone https://codeberg.org/outlast/nixos
cd nixos
# 5. Partition and install. Replace <name> with the host's attrset key in flake.nix.
host="<name>"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./hosts/${host}/disko.nix
sudo nixos-install --flake .#${host}
```

> `nixos-install` lays down the system to the target disk and writes the first user.
> The `z` tmpfiles rule in `flake.nix`'s `sopsShared` keeps the perms at `0640 root:sops` after every boot, without modifying content. Manual copy with the right group on first install is enough; reboots will not need it.

```bash
# 5. Reboot into the new system, then activate both trees.
reboot
sudo nixos-rebuild switch --flake /path/to/nixos#<host>
home-manager switch --flake /path/to/nixos#<user>
```

> The user-side rebuild runs without sudo and reads `/etc/sops-nix/key.txt`. The keyfile is readable because `users.users.<user>.extraGroups = [ "sops" ]` is set declaratively in `flake.nix`'s `sopsShared`. Run the rebuilds in this order on a fresh login session so the group membership is already in effect for the user systemd instance that `home-manager switch` spawns.

## Secret management

`flake.nix`'s `sopsShared` exports `SOPS_AGE_KEY_FILE=/etc/sops-nix/key.txt` to the user's interactive shell (via `home.sessionVariables`) and to the systemd user service. That means plain `sops` invocations resolve the key automatically on hosts that have the per-host key in place.

```bash
# Edit a host's secrets file. Decrypts to plaintext in $EDITOR; on save,
# sops re-encrypts against the recipients in .sops.yaml.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops hosts/<host>/secrets.yaml
```

> `sops` opens an empty buffer if the file does not yet exist; type the plaintext, save, and the file appears as encrypted YAML on disk.

```bash
# Print the decrypted file to stdout. Used after editing to confirm the
# plaintext looks right, and during rotation to compare against the old copy.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops -d hosts/<host>/secrets.yaml
```

```bash
# Print a single key only. Useful for sanity checks against a backend
# without leaking the rest of the file.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops -d --extract '["tailscale", "one-of-key"]' hosts/<host>/secrets.yaml
```

```bash
# Re-encrypt to the recipients currently listed in .sops.yaml without opening
# an editor. Run this after adding a new <host> anchor, after rotating the
# master key, or after switching path_regex blocks.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops updatekeys --config .sops.yaml hosts/<host>/secrets.yaml
```

```bash
# Decrypt with a key file at an arbitrary path. Set the variable just for
# one command when working from a workstation that does not have the
# per-host key in place -- say, when verifying a file from a backup.
SOPS_AGE_KEY_FILE=/tmp/<host>.age.key \
  nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops -d hosts/<host>/secrets.yaml
```

> All four commands above run on the admin workstation. The per-host private key never travels - the host copy is provisioned at install time via the `Deploying a host` flow, and the admin edits via the `*master` anchor in `.sops.yaml`.

## Repository walkthrough

```
flake.nix                                # inputs, hosts registry, sops/options plumbing
options/                                 # my.* declarations, read by both trees
  default.nix                            # barrel for the eight files below
  my.nix                                 # declares the `my.*` namespace
  identity.nix                           # my.{username,shell,avatar,editor}
  mail.nix                               # my.mail.{address,password,host,port,sslType}
  theme.nix                              # my.theme.{size.edge-gap,icon.path,color.dark.*}
  desktop.nix                            # my.{wallpaper,terminal,opacity,wm}.*
  fonts.nix                              # my.font.{family.{},packages}
  system.nix                             # my.{tailscale,filesystem,virt,steam,hardware}.*
hosts/<host>/                            # one directory per host, separate from each other
  nixos.nix                              # system tree entrypoint + stateVersion + module imports
  home.nix                               # home tree entrypoint + stateVersion + module imports
  config.nix                             # my.* values + sops.secrets, imported by both trees
  disko.nix                              # disk layout
  secrets.yaml                           # sops-encrypted, recipients per .sops.yaml
modules/                                 # the module tree, read by every host
  common/nixpkgs.nix                     # nixpkgs.overlays shared by both trees
  home/                                  # home-manager modules
    core/                                # shell, identity, xdg, environment
    desktop/                             # session, panel, launchers, notifications, wallpaper
    apps/                                # browser, mail, media, terminals, files, IDE
  system/                                # NixOS modules
    core/                                # networking, storage, users, fonts, audio, boot
    desktop/                             # session
    apps/                                # steam
```

> Three top-level directories, that's all. Pick the one that matches the file's role: `options/` for `my.*` declarations, `hosts/<host>/` for host-scoped settings, `modules/` for shared logic - and stay there. A setting that differs per machine stays in `hosts/<host>/`; a setting the same on every host that uses a feature stays in `modules/`.
