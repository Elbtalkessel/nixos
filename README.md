## NixOS system and home configuration files

![Dekstop](./preview.png?raw=true)

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

## To do

- home/bin/screenshot.sh: read session variables instead of hard-coded values.
- add [USB Guard](https://usbguard.github.io/)
- setup system auto upgrade
- setup home manager auto upgrade
- flatpak declarative app install and app permissions
- qemu declarative machine definition (ubuntu 20.04, windows)
- cleanup setup scripts, use [disko](https://github.com/nix-community/disko)
- integrate [sops-nix](https://github.com/Mic92/sops-nix?tab=readme-ov-file#Flakes)
  - add github access token to it, https://github.com/NixOS/nix/issues/6536#issuecomment-1254858889 and https://nix.dev/manual/nix/2.18/command-ref/conf-file#file-format
  - add samba creds, /root/secrets/samba
  - add wg creds, /root/secrets/wg/wg0.conf
  - add optimizer license key
- replace hardcode paths in environment.nix and ide.nix
