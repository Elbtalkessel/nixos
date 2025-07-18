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
    mpv
    xdg-user-dirs
    pavucontrol
    calibre
    telegram-desktop
    hyprpicker
    wl-clipboard-rs
    libreoffice
    flatpak
    gnome-software

    # CLI for searching packages on search.nixos.org
    nix-search-cli

    # Network
    curl
    wget
    arp-scan
    dig
    bruno

    # Development
    lazydocker
    lazygit
    devenv
    tlm
    python313Packages.ipython
    deno
    yaegi

    # Tools
    ncdu
    btop
    brightnessctl
    # Obvious Unified Compression Helper
    # ouch d file.zip
    # ouch c file.7z
    # ouch l file.tar.zip.7z.gs.xz.bz.bz3.lz.sz.zst.rar.br
    ouch

    usbdrivetools
    bootdev
    neovim

    # Shell scripts
    (writeShellScriptBin "screen" (builtins.readFile ../bin/screenshot.sh))
    (writeShellScriptBin "setbg" (builtins.readFile ../bin/setbg.sh))
  ];
}
