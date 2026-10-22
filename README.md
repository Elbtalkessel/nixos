# NixOS Configuration

## What is it

Flake-based NixOS + Home Manager config. One `flake.nix` declares every host; rebuilding produces both the system tree and the user tree from a single source.

## Structure

Three top-level directories. Pick the one that matches the file's role.

```
flake.nix                        # inputs, hosts registry, sops/options wiring
modules/                          # shared definitions, imported by every host
hosts/<host>/                    # bulk of the config, one directory per host
  nixos.nix                      # system tree entrypoint + stateVersion + imports
  home.nix                       # home tree entrypoint + stateVersion + imports
  config.nix                     # my.* values + sops.secrets, imported by both trees
  disko.nix                      # disk layout
  filesystem.nix                 # extra mounts (optional, omen-only today)
  secrets.yaml                   # sops-encrypted, recipients per .sops.yaml
options/                         # my.* declarations, read by both trees
```

Most of the real config lives under `hosts/<host>/`. Reach for `modules/` only when two or more hosts genuinely share something — locale plumbing, nix settings, certificates, and a shared `nixpkgs` overlay today.

## Adding a host

Five edits and one runtime step.

```nix
# 1. Register the host in flake.nix's `hosts` attrset.
hosts.<name> = {
  user = "<user>";            # primary user; also the home-manager key
  sops = <true | false>;      # true if the host owns a secrets.yaml
};
```

```bash
# 2. Copy a working host as a template.
mkdir hosts/<name>
cp -r hosts/omen/{nixos,home,config,disko}.nix hosts/<name>/
```

Edit the four files: `nixos.nix` (hostName, stateVersion, imports), `disko.nix` (layout), `home.nix` (stateVersion, imports), `config.nix` (`my.*` values + `sops.secrets`).

```bash
# 3. Mint a per-host age key on the admin box. <name> is the hostname.
nix shell github:NixOS/nixpkgs/nixos-unstable#age -c age-keygen -o /tmp/<name>.age.key
```

```yaml
# 4. .sops.yaml - add a public anchor and a creation_rules block:
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
# 5. Re-encrypt so the file picks up the new recipient set.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops updatekeys hosts/<name>/secrets.yaml
```

The private half never enters the repo. The host copy is provisioned at install time via the deploy flow below.

## Deploying a host

Boot the target machine from the NixOS live ISO. SSH comes after the first boot, so everything below runs on the target console.

```bash
passwd                                              # root password for the live session
hostname -I                                         # note the IP for the next step
```

On the admin box, push the per-host key:

```bash
scp /tmp/<name>.age.key nixos@<ip>:/tmp/
```

Back on the target console, provision the keyfile and install:

```bash
sudo mkdir -p /mnt/etc/sops-nix
sudo install -m 0640 -o root -g users /tmp/<name>.age.key /mnt/etc/sops-nix/key.txt
git clone https://gitea.x.home.arpa/nix/nixos.git
cd nixos
host="<name>"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./hosts/${host}/disko.nix
sudo nixos-install --flake .#${host}
reboot
```

On the freshly-booted system, activate both trees:

```bash
sudo nixos-rebuild switch --flake /path/to/nixos#<host>
home-manager switch --flake /path/to/nixos#<user>
```

`flake.nix`'s sops wiring (`getSopsConfig` plus the per-host module in `nixosFor`) keeps the keyfile at `0640 root:sops` after every boot (no content touch), adds the user to the `sops` group, and exports `SOPS_AGE_KEY_FILE=/etc/sops-nix/key.txt` to the interactive shell and to the user systemd instance.

### MicroVM guests

MicroVMs do not use the bare-metal install flow. Instead, the host keeps each
guest's age private key outside the Nix store and shares it into the guest at
boot time:

```bash
# On the admin box (the microvm host), keep per-guest keys here.
# <name> is the guest hostname.
install -D -m 0600 -o $USER -g users /tmp/<name>.age.key \
  ~/.config/sops/age/<name>.age.key
```

`flake.nix` creates a systemd service per microvm guest that runs before
`microvm@<name>.service`, copies `~/.config/sops/age/<name>.age.key` into
`/var/lib/microvm/<name>/sops-nix/key.txt`, and the guest mounts that directory
as `/etc/sops-nix` via virtiofs. The private key never enters the Nix store;
only the script that performs the copy is in the store.

A guest that sets `updateFlake` — every guest in this repo does — is installed
**once**. `install-microvm-<name>.service` is guarded by
`ConditionPathExists = "!/var/lib/microvms/<name>"`, so a host rebuild does not
replace the guest's runner. Update and restart it with the imperative command on
the host:

```bash
# Rebuild the guest from the flakeref stored in /var/lib/microvms/<name>/flake
# (that is `updateFlake`, i.e. the remote default branch), then restart it.
microvm -u -R <name>
```

`nixos-rebuild switch --flake /path/to/nixos#<host>` still rebuilds the host and
can restart the guest, but it restarts the **same** runner: it does not pick up
new guest configuration. Rebuilding also does not bump package versions — run
`nix flake update` first if that is the intent. To deploy an unmerged branch,
point `/var/lib/microvms/<name>/flake` at that branch before updating.

## Secrets

```bash
# Edit a host's secrets in $EDITOR; sops re-encrypts on save.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops hosts/<host>/secrets.yaml

# Print the decrypted file to stdout.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops -d hosts/<host>/secrets.yaml

# Print a single key.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops -d --extract '["<service>", "<key>"]' hosts/<host>/secrets.yaml
```
