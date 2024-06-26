{ config, pkgs, ... }:
{

  imports = [
    ./aliases.nix
    ./environment.nix
    ./modules/alacritty.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/hyprland.nix
    ./modules/mako.nix
    ./modules/waybar.nix
    ./modules/lf.nix
  ]; 
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "risus";
  home.homeDirectory = "/home/risus";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
  programs.fzf = {
    enable = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };

  services = {
    udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
  };

  xdg.configFile."tofi/config".source = ./config/tofi/config;
  xdg.configFile."lvim/config.lua".source = ./config/lvim/config.lua;

  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };
    
  # https://discourse.nixos.org/t/virt-manager-cannot-create-vm/38894/2
  # virt-manager doesn't work without it
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    # same size on wayland and xwayland
    size = 24;
  };

  dconf = {
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
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
    lazydocker
    podman-compose
    pavucontrol

    # Web access
    wget
    curl
    slack

    # Capture
    grim
    slurp
    wl-clipboard
    # xclip + clipnotify + cliphist service is workaround for issue:
    # "Clipboard synchronization between wayland and xwayland clients broken"
    # https://github.com/hyprwm/Hyprland/issues/6132
    xclip
    clipnotify

    # Desktop environment
    tofi
    zathura
    libnotify
    imv
    mpv
    xdg-user-dirs
    brightnessctl
    gnome.gnome-calculator
    wl-screenrec

    # Console and text-based UI apps
    lazygit
    btop

    # Tools
    arp-scan
    httpie
    ripgrep
    ncdu
    python311Packages.ipython

    # Editors and IDEs
    lunarvim
    jetbrains-toolbox

    # When I get used to devenv, I will remove this
    pre-commit
    ruff
    python311Packages.invoke
    nodejs
    go

    # Shell scripts
    (writeShellScriptBin "screen" (builtins.readFile ./bin/screenshot.sh))
    # Requires xclip and clipnotify, workaround, see above in packages.
    (writeShellScriptBin "clipsync" (builtins.readFile ./bin/clipsync.sh))
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".local/share/python_history".text = '''';

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
}
