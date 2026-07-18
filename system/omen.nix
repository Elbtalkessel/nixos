# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ./disko/omen.nix

    ./modules/filesystem
    ./modules/hardware
    ./modules/llm
    ./modules/networking
    ./modules/specialisation
    ./modules/vm
    ./modules/web
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/boot.nix
    ./modules/fonts.nix
    ./modules/i18n.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/session.nix
    ./modules/sops.nix
    ./modules/steam.nix
    ./modules/users.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes pipe-operators";
      # devenv requirement, allows devenv to manager caches.
      trusted-users = [ config.my.username ];
      substituters = [ "https://cache.nixos-cuda.org" ];
      trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
    };
  };

  # SECURITY
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    # ****** when typing password, insecure, but looks better :)
    sudo.extraConfig = ''
      Defaults pwfeedback
    '';
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
