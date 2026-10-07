# atlas -- a headless VM that runs opencode with the oh-my-openagent plugin.
{
  pkgs,
  lib,
  modulesPath,
  config,
  disko,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    disko.nixosModules.disko
    ./disko.nix
    ./config.nix

    ../../modules/system/core/locale
    ../../modules/system/core/nix-settings
  ];

  networking.hostName = "atlas";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # A new host, so start at the release the system is actually built from.
  system.stateVersion = "26.11";

  # The disko layout carries an ESP, so `nixos-install` needs a bootloader for
  # the result to be bootable.
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    device = "/dev/vda";
  };

  networking.networkmanager.enable = true;

  # The documented install flow configures the machine over SSH.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.${config.my.username} = {
    isNormalUser = true;
    description = "atlas opencode host";
    hashedPasswordFile = config.sops.secrets."users/${config.my.username}/password".path;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    useDefaultShell = true;
  };
}
