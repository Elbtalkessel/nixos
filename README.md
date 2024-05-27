NixOS system and home configuration files
----

## Requirements

- NixOS (with flakes feature enabled).
- Optionally devenv (https://devenv.sh/getting-started/) for git hooks.

## Channel list
home-manager https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz
nixos https://nixos.org/channels/nixos-23.11
nixos-hardware https://github.com/NixOS/nixos-hardware/archive/master.tar.gz
nixos-unstable https://nixos.org/channels/nixos-unstable

## Structure

```plain
flake.nix
|- system/configuration.nix
|- home/home.nix
```

It is possible to use it without flake, to do so copy `system/*` to `/etc/nixos/` and/or `home/*` to `~/.config/home-manager/`.

## Modus operandi
```
# Activate dev shell, will install git hooks.
devenv shell
# ... edit home or system configuration and commit changes ...
git push  # calls home or nixos switch command if home or system configuration has changed
```

## To do
- learn how to rebind keys using `solaar` or remove the dependency and integrate [logiops](https://github.com/PixlOne/logiops) from old config files.
- apply float rule to solaar window.
- add nix-collect-garbade task (something similar for home-manager too?).
- remove apple fonts submodule.
- home/bin/screenshot.sh: read session variables instead of hardcoded values.
- setup ubuntu 20.04 virtual machine
- prompt for a key if inserted an encrypted pendrive
- add https://usbguard.github.io/
- setup wireguard
- call switch hooks only on `git push`
- setup system auto upgrade
- setup home manager auto upgrade
- fix tofi app launcher broken desktop entries
- flatpak declarative app install and app permissions
- qemu declarative machine definition
