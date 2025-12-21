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
    gnome-software
    obsidian
    # Sometimes drag-n-drop is only option
    nautilus

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

    # From nixpkgs-custom overlay
    waifu
    usbdrivetools
    bootdev

    # Shell scripts
    (writeShellScriptBin "setbg" (builtins.readFile ../bin/setbg.sh))
    (nuenv.writeShellApplication {
      name = "lsd";
      text = builtins.readFile ../bin/lsd.nu;
    })
    (nuenv.writeShellApplication {
      name = "hyprswitch";
      text = builtins.readFile ../bin/hyprswitch.nu;
    })
  ];
}
