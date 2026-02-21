{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Web access
    slack
    mattermost-desktop

    # Capture
    grim
    slurp

    # Desktop environment
    zathura
    libnotify
    xdg-user-dirs
    pavucontrol
    telegram-desktop
    hyprpicker
    wl-clipboard-rs
    libreoffice

    # CLI for searching packages on search.nixos.org
    # General
    nix-search-cli
    # Network
    curl
    wget
    arp-scan
    dig
    # For exposing local servers to public.
    cloudflared
    # Development
    lazydocker
    lazygit
    devenv
    python313Packages.ipython
    deno
    yaegi
    vagrant
    neovim
    # Tools
    ncdu
    btop
    brightnessctl
    # Obvious Unified Compression Helper
    # ouch d file.zip
    # ouch c file.7z
    # ouch l file.tar.zip.7z.gs.xz.bz.bz3.lz.sz.zst.rar.br
    ouch
    # Deleting into trash bin
    # https://github.com/umlx5h/gtrash
    gtrash
    chafa
    tldr

    # From nixpkgs-custom overlay
    waifu
    usbdrivetools
    bootdev
  ];
}
