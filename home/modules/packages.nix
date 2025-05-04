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
    gthumb
    libreoffice

    # CLI for searching packages on search.nixos.org
    nix-search-cli

    # Network
    curl
    wget
    arp-scan

    # Development
    lazydocker
    lazygit
    devenv

    # Tools
    ncdu
    translate-shell
    btop
    brightnessctl

    # Gaming
    bottles
    minigalaxy

    # Shell scripts
    (writeShellScriptBin "screen" (builtins.readFile ../bin/screenshot.sh))
    # Reqired from imv.nix for applying a wallpaper
    (writeShellScriptBin "wallpaper" (builtins.readFile ../bin/wallpapper.sh))
  ];
}
