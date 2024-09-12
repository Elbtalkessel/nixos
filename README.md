## NixOS system and home configuration files

## Deploy

The `setup` folder contains some scripts for deploying nixos on a blank drive, LUKS on LLM and systemd boot (optionally grub for old machines).

## Install

1. Enable flake support in your current nixos configuration:

```nix
nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
};
```

2. Enable standalone home-manager: [Standalone installation](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)

3. Apply configurations:

```sh
sudo nixos-rebuild switch --flake ./
home-manager switch --flake ./
```

## Dev

Nixvim submodule update:

```
nix flake lock --update-input nixvim
home-manager switch --flake ./
```

## To do

- add nix-collect-garbage task.
- home/bin/screenshot.sh: read session variables instead of hard-coded values.
- add [USB Guard](https://usbguard.github.io/)
- setup system auto upgrade
- setup home manager auto upgrade
- flatpak declarative app install and app permissions
- qemu declarative machine definition (ubuntu 20.04, windows)
