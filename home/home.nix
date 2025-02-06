{ pkgs, ... }:
{
  imports = [
    ./aliases.nix
    ./environment.nix
    ./modules/alacritty.nix
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/hyprland.nix
    ./modules/mako.nix
    ./modules/waybar.nix
    ./modules/lf.nix
    ./modules/clipboard.nix
    ./modules/qutebrowser.nix
    ./modules/browser.nix
    ./modules/gpg.nix
    ./modules/passman.nix
    ./modules/imv.nix
    ./modules/music.nix
    ./modules/ide.nix
    ./modules/theme.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "risus";
    homeDirectory = "/home/risus";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

      # Web access
      wget
      curl
      slack
      mattermost-desktop

      # Capture
      grim
      slurp

      # Desktop environment
      tofi
      zathura
      libnotify
      mpv
      xdg-user-dirs
      brightnessctl
      pavucontrol
      calibre
      telegram-desktop

      # Console and text-based UI apps
      lazygit
      btop
      nvtopPackages.full

      # Tools
      arp-scan
      httpie
      ncdu
      python311Packages.ipython

      # Dev Tools
      lazydocker
      devenv

      # Shell scripts
      (writeShellScriptBin "screen" (builtins.readFile ./bin/screenshot.sh))
      # Reqired from imv.nix for applying a wallpaper
      (writeShellScriptBin "wallpaper" (builtins.readFile ./bin/wallpapper.sh))
      (writeShellScriptBin "repl" (builtins.readFile ./bin/repl.sh))
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    #file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    #};
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  services = {
    # USB automount
    udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
  };

  xdg.configFile = {
    # Tofi laucher theme
    "tofi/config".source = ./config/tofi/fullscreen;
    "wget/wgetrc".source = ./config/wget/wgetrc;
    # TMPFS caching, https://github.com/direnv/direnv/wiki/Customizing-cache-location#direnv-cache-on-tmpfs
    "direnv/direnvrc".source = ./config/direnv/direnvrc;
    "process-compose/settings.yaml".source = ./config/process-compose/settings.yaml;
  };

  # quemu requiers it, but virtualisation settings are part of the
  # system configuration, not home. So it is here.
  dconf = {
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
