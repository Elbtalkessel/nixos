# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  modulesPath,
  nixos-hardware,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # Mostly from https://github.com/NixOS/nixos-hardware/blob/master/omen/16-n0280nd/default.nix
    # The rest (kernel modules and prime config is in the omen.nix)
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd

    ./disko/omen.nix

    ./modules/filesystem
    ./modules/networking
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/boot.nix
    ./modules/fonts.nix
    ./modules/hardware.nix
    ./modules/i18n.nix
    ./modules/llm.nix
    ./modules/nvidia.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/session.nix
    ./modules/sops.nix
    ./modules/steam.nix
    ./modules/users.nix
    ./modules/virtualisation.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      # devenv requirement, allows devenv to manager caches.
      trusted-users = [ config.my.username ];
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
