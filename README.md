NixOS system and home configuration files
----


# Requirements

- NixOS (with flakes feature enabled).
- Optionally devenv (https://devenv.sh/getting-started/) for git hooks.


# Structure

flake.nix
|- system/configuration.nix
|- home/home.nix

It is possible to use it without flake, to do so copy `system/*` to `/etc/nixos/` and/or `home/*` to `~/.config/home-manager/`.


# Modus operandi
```
# Activate dev shell, will install git hooks.
devenv shell
# ... edit home or system configuration and commit changes ...
git push  # calls home or nixos switch command if home or system configuration has changed
```
