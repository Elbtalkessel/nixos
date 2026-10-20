{ pkgs, ... }:
{
  nixpkgs.config.allowUnfreePackages = [
    # "limo"
    "ouch"
    "plexamp"
    "vagrant"
  ];

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
    (ouch.overrideAttrs {
      enableUnfree = true;
    }) # archiving / unarchiving.
    gtrash # trash bin.
    scrcpy # android screen capture.
    android-tools # mostly for android debug bridge.

    # Apps
    zathura # PDF viewer.
    xournalpp # Note taking / PDF signing.
    pavucontrol # UI for controlling audio input / output.
    telegram-desktop # comms.
    mattermost-desktop # comms.
    neovim # terminal editor.
    #proton-vpn # vpn client.
    plexamp

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
    jless # tui json/yaml viewer.
    yt-dlp
    difftastic # better diff tool
    bootdev-cli
    sshp
    wf-recorder

    # Development
    mockoon # API mocking.
    bruno # API documentation.
    cloudflared # Tunneling local servers.
    lazydocker # docker tui.
    lazygit # git tui.
    # REPLs / Languages
    python313Packages.ipython # python.

    # Games
    # can't build.
    #(limo.overrideAttrs (_: {
    #  withUnrar = true;
    #}))

    # Custom
    gimd
    usbdrivetools
  ];

  #xdg.autostart.entries = [
  #  "${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"
  #];
}
