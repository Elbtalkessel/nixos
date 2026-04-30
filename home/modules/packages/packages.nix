{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # Core
    wl-clipboard-rs # clipboard support.
    libnotify # desktop notifications.
    xdg-user-dirs # desktop directories support.

    # General / Support
    grim # screenshot.
    slurp # returns selected on screen region, for taking screenshots.
    hyprpicker # get HEX color under pointer.
    brightnessctl # monitor brightness control.
    (pkgs.writeShellApplication {
      name = "set-brightness";
      text = # bash
        ''
          ${lib.getExe pkgs.brightnessctl} s "$1"
        '';
    }) # Wrapper for unified way to control brightnes, in case if underlying tool change.
    ouch # archiving / unarchiving.
    gtrash # trash bin.
    scrcpy # android screen capture.
    android-tools # mostly for android debug bridge.

    # Apps
    zathura # PDF viewer.
    pavucontrol # UI for controlling audio input / output.
    telegram-desktop # comms.
    slack # corpo comms.
    mattermost-desktop # correct comms.
    neovim

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
    tldr # quick documentation on a utility.

    # Development
    mockoon # API mocking.
    cloudflared # Tunneling local servers.
    lazydocker # docker tui.
    lazygit # git tui.
    devenv # dev envs management.
    # REPLs / Languages
    python313Packages.ipython # python.

    # Custom
    gimd
    usbdrivetools
    bootdev
  ];
}
