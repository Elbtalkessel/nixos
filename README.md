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
home-manager switch --flake /path/to/nixos#<user>@<host>
```

`flake.nix`'s sops wiring (`getSopsConfig` plus the per-host module in `nixosFor`) keeps the keyfile at `0640 root:users` after every boot (no content touch) and exports `SOPS_AGE_KEY_FILE=/etc/sops-nix/key.txt` to the interactive shell and to the user systemd instance.

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

## First deploy: coach

`coach` is the living-room appliance: a Lenovo m720q (i3-9100T / UHD 630 / 8 GB /
256 GB NVMe) that boots straight into Kodi and is controlled over SSH or an
air-mouse. It has `sops = false` — no `secrets.yaml`, no age key — so the
generic "Deploying a host" flow's key-minting steps do **not** apply. The box
ships with Windows; the first deploy replaces it.

### 0. Gather hardware facts from Windows (before wiping)

Run these in PowerShell on the Windows install. They confirm the assumptions the
config already encodes, and they are the only way to double-check the disk path
`disko.nix` targets (`/dev/nvme0n1`):

```powershell
# Disk: confirm a single NVMe. If BusType is SATA, fix disko.nix's device path.
Get-Disk | Format-Table Number, FriendlyName, BusType, @{n='SizeGB';e={[math]::Round($_.Size/1GB,1)}}, PartitionStyle -AutoSize

# Firmware: must say UEFI. systemd-boot needs UEFI, not legacy BIOS.
Confirm-SecureBootUEFI

# Network: note the Ethernet adapter; a Wi-Fi dongle lands later.
Get-NetAdapter | Format-Table Name, InterfaceDescription, Status, MacAddress -AutoSize

# Bluetooth? Decides whether BT Xbox controllers (xpadneo) apply. No output = no BT.
Get-PnpDevice -Class Bluetooth -ErrorAction SilentlyContinue | Select-Object Status, FriendlyName

# Sanity: confirm i3-9100T + 8 GB, which the power profile assumes.
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed
```

### 1. Boot the NixOS live ISO

Flash the current NixOS ISO to USB, boot the m720q from it (UEFI), and plug in
Ethernet. Everything below runs on the target console.

### 2. Partition and install

```bash
sudo -i                                              # root in the live session
ip a                                                 # note the IP if you want SSH
git clone https://gitea.x.home.arpa/nix/nixos.git
cd nixos

# Wipe and lay down the disk per hosts/coach/disko.nix.
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./hosts/coach/disko.nix

# Install. `--no-root-password` because root is key-only (PermitRootLogin
# prohibit-password); the operator SSH key is already in root's authorized_keys.
nixos-install --flake .#coach --no-root-password
reboot
```

### 3. First boot

greetd auto-logs the `kodi` user into Kodi (GBM standalone). Kodi should come up
on the TV within a minute. Confirm it from the admin box:

```bash
ssh risus@coach.local                              # avahi; or the IP from step 2
sudo nixos-rebuild switch --flake 'github:nix/nixos#coach'
home-manager switch --flake 'github:nix/nixos#risus@coach'
```

`sudo` is passwordless for `risus` (key-only account, no password to type).

### 4. Post-deploy, inside Kodi

The system carries Kodi + Moonlight + RetroArch; everything else is installed
interactively from Kodi:

1. **Plex** — install the "PlexKodiConnect" community addon, point it at the Plex
   host, sign in. It mirrors the Plex library into Kodi and direct-plays locally.
2. **YouTube** — the official Kodi addon, or a piped/newpipe-style alternative.
3. **Emulators** — launch RetroArch from a Kodi launcher entry; ROMs come from
   `romm.x.home.arpa`.
4. **Streaming** — launch Moonlight from Kodi, pair it with Sunshine/GeForce on
   the gaming PC.
5. **G10S air-mouse** — arrows/OK/back/home/volume work out of the box (plain HID
   scancodes); the red power key is IR-learn-only, so suspend comes from the
   logind `HandlePowerKey` rule instead.

## Secrets

```bash
# Edit a host's secrets in $EDITOR; sops re-encrypts on save.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops hosts/<host>/secrets.yaml

# Print the decrypted file to stdout.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops -d hosts/<host>/secrets.yaml

# Print a single key.
nix shell github:NixOS/nixpkgs/nixos-unstable#sops -c sops -d --extract '["<service>", "<key>"]' hosts/<host>/secrets.yaml
```
