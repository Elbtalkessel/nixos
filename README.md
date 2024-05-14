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
- `mkscrn` doesn't work when called as `hyprctl dispatch exec mkscrn`.
- learn how to rebind keys using `solaar` or remove the dependency and integrate [logiops](https://github.com/PixlOne/logiops) from old config files.
- ~~greetd is broken, it doesn't start Hyprland after logout.~~
- apply git hook when content of `home/bin` or `flex.nix` changes.
- apply float rule to solaar window.
- add nix-collect-garbade task (something similar for home-manager too?).
- replace `nix profile install apple-fonts.nix#sf-pro-nerd` with declarative approach.
- global font definition (stylix?)
