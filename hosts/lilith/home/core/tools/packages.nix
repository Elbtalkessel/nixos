{ pkgs, ... }:
{
  nixpkgs.config.allowUnfreePackages = [
    "ouch"
    "vagrant"
  ];

  home.packages = with pkgs; [
    # Core
    wl-clipboard-rs # clipboard support.
    libnotify # desktop notifications.
    xdg-user-dirs # desktop directories support.

    # General / Support
    brightnessctl # monitor brightness control.
    (ouch.overrideAttrs {
      enableUnfree = true;
    }) # archiving / unarchiving.

    # Apps
    pavucontrol # UI for controlling audio input / output.
    neovim # terminal editor.

    # VM
    vagrant

    # CLIs
    nix-search-cli # `nix search` alternative.
    curl # curl.
    wget # non-interactive network downloader.
    arp-scan # for local network probing.
    dig # DNS lookup.
    mimeo # file opener based on its mime.
    ncdu # disk usage visualizer.
    btop # system usage visualizer.
    chafa # image preview in terminal.
    jless # tui json/yaml viewer.
    difftastic # better diff tool

    # Custom
    usbdrivetools
  ];
}
