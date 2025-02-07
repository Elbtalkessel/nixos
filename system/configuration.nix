# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  config,
  ...
}:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "Hyprland";
  username = "risus";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    ./modules/logiops.nix
    ./modules/samba.nix
    ./modules/virtualisation.nix
    #./modules/wireguard.nix
    ./modules/flatpak.nix
    ./modules/ollama.nix
    ./modules/bluetooth.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    kernel.sysctl = {
      # Allow starting server @ :80
      "net.ipv4.ip_unprivileged_port_start" = 80;

      # Inotify is a kernel module that monitors file system events such as file creation,
      # deletion and modification. It allows other application to observe these changes.
      # Double amount of the default value.
      "fs.inotify.max_user_watches" = "1048576";
      # I have on average 400 processes running, double it and add a bit more just in case.
      "fs.inotify.max_user_instances" = "1024";
    };

    # https://lore.kernel.org/io-uring/f4bfc61b-9fe6-466a-a943-7143ed1ec804@kernel.dk/T/
    # Latest kernel 6.6.59 has an issue with the io_uring
    # Two options, or use kernel 6.11.6 or zen kernel which is 6.11.5
    # It seems switching to the zen kernel is the best solution as it forked from the stable kernel version
    # Another option is to pin a specific kernel version:
    # https://nixos.wiki/wiki/Linux_kernel
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
    };
    secrets = {
      "users/risus/password" = {
        # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
        neededForUsers = true;
      };
      "wireless.env" = { };
      "moon/risus" = { };
      "optimizer/license" = {
        owner = config.users.users.risus.name;
      };
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      # devenv requirement, allows devenv to manager caches.
      trusted-users = [ "risus" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
    };
  };

  # Enable networking
  networking = {
    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wireless.env".path ];

        profiles = {
          # --- HOME WIFI ---
          home-wifi = {
            connection.id = "home-wifi";
            connection.type = "wifi";
            wifi.ssid = "$HOME_WIFI_SSID";
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$HOME_WIFI_PASSWORD";
            };
          };
          # ---
        };
      };
    };

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
    firewall.allowedTCPPorts = [
      80
      443
      8000
      9567
    ];
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
  };

  # PROGRAMS
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    # virt-manager requires dconf to remember settings
    dconf.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
    zsh.enable = true;
  };

  # USERS
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/risus/password".path;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "tss"
    ];
    shell = pkgs.nushell;
  };

  # SECURITY
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    # See:
    #   home/modules/hyprland.nix (hyprlock)
    #   https://mynixos.com/home-manager/option/programs.hyprlock.enable
    pam.services.hyprlock = { };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
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
    # Daemon for updating some devices' firmware
    # https://github.com/fwupd/fwupd
    fwupd.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
    home-manager
    git
    neovim
    curl
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.overpass
      noto-fonts-emoji
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
        monospace = [ "Overpass Nerd Font Mono" ];
        sansSerif = [ "Overpass Nerd Font" ];
        serif = [ "Overpass Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
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
