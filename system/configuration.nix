# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "Hyprland";
  username = "risus";
in {
  imports = [
    ./hardware-configuration.nix
    ./modules/logiops.nix
    ./modules/samba.nix
    ./modules/virtualisation.nix
    ./modules/wireguard.nix
    ./modules/flatpak.nix
    ./modules/ollama.nix
    ./modules/bluetooth.nix
  ];

  boot = {
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/6eb60a50-cb6b-48c3-82da-a3ef3aee9a02";
        preLVM = true;
        allowDiscards = true;
      };
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };

    kernel.sysctl = {
      # Allow starting server @ :80
      "net.ipv4.ip_unprivileged_port_start" = 80;
    };
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    # devenv requirement, allows devenv to manager caches.
    trusted-users = ["root" "risus"];
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "omen";
    extraHosts = ''
      192.168.1.90 moon
    '';

    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = true;

    # Open ports in the firewall.
    # Allow HTTP and HTTPS traffic, required for guest vm to access host,
    # ideally to narrow down to specific IP.
    firewall.allowedTCPPorts = [80 443];
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    cudaSupport = true;
  };

  # PROGRAMS
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # virt-manager requires dconf to remember settings
  programs = {
    dconf.enable = true;
    fish.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];
  };

  # USERS
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["networkmanager" "input" "wheel" "video" "audio" "tss"];
    shell = pkgs.fish;
  };

  # SECURITY
  security.rtkit.enable = true;
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # List services that you want to enable:
  services = {
    udisks2.enable = true;
    # Change runtime directory size
    logind.extraConfig = "RuntimeDirectorySize=8G";
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # Gretter with autologin
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${session}";
          user = "${username}";
        };
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${session}";
          user = "greeter";
        };
      };
    };
    gnome.gnome-keyring.enable = true;
  };

  xdg = {
    portal.enable = true;
    portal.config.common.default = "*";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
    home-manager
    # there is also home-manager service for hyprpaper, but it does not install hyprpaper package :(
    hyprpaper
    zed-editor
  ];

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["Overpass"];})
    ];
    fontconfig = {
      enable = true;
      subpixel.rgba = "rgb";
      # https://mynixos.com/nixpkgs/option/fonts.fontconfig.hinting.style
      hinting = {
        enable = true;
        style = "slight";
      };
      # https://mynixos.com/nixpkgs/option/fonts.fontconfig.antialias
      antialias = true;
      defaultFonts = {
        monospace = ["Overpass Nerd Font Mono"];
        sansSerif = ["Overpass Nerd Font"];
        serif = ["Overpass Nerd Font"];
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
