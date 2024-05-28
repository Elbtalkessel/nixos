# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "Hyprland";
  username = "risus";
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/logiops.nix
    ./modules/samba.nix
    ./modules/virtualisation.nix
    ./modules/wireguard.nix
  ];

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/6eb60a50-cb6b-48c3-82da-a3ef3aee9a02";
      preLVM = true;
      allowDiscards = true;
    };
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernel.sysctl = {
    # Allow starting server @ :80
    "net.ipv4.ip_unprivileged_port_start" = 80;
  };

  nix.settings.experimental-features = "nix-command flakes";
  # devenv requirement, allows devenv to manager caches.
  nix.settings.trusted-users = [ "root" "risus" ];


  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "omen";
  networking.extraHosts = ''
    192.168.1.90 moon
  '';
  # Open ports in the firewall.
  # Allow HTTP and HTTPS traffic, required for guest vm to access host,
  # ideally to narrow down to specific IP.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;


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
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);


  # PROGRAMS
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # virt-manager requires dconf to remember settings
  programs.dconf.enable = true;
  programs.fish.enable = true;


  # USERS
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "tss" ];
    shell = pkgs.fish;
  };


  # HARDWARE
  # Bluetooth
  # doesn't work
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;


  # SECURITY
  security.rtkit.enable = true;
  security.polkit.enable = true;
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

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.udisks2.enable = true;
  # Change runtime directory size
  services.logind.extraConfig = "RuntimeDirectorySize=8G";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Gretter with autologin
  services.greetd = {
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
  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;
  xdg = {
    portal.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
    home-manager
  ];


  fonts.packages = with pkgs; [
    (nerdfonts.override{ fonts = ["Overpass"]; })
  ];
  fonts.fontconfig = {
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
