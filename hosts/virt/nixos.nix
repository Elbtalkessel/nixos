{
  lib,
  config,
  disko,
  ...
}:
{
  imports = [
    disko.nixosModules.disko
    ./disko.nix
    ./config.nix
  ];

  networking.hostName = "virt";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # A new host, so start at the release the system is actually built from.
  system.stateVersion = "26.11";

  # The disko layout carries an ESP, so `nixos-install` needs a bootloader for
  # the result to be bootable.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "/dev/vda";
  };

  networking.networkmanager.enable = true;

  # The documented install flow configures the machine over SSH.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  # No password is committed here. Set one with `passwd <name>` after the first
  # boot, or set `initialPassword` deliberately when building a disposable image.
  users.users.${config.my.username} = {
    isNormalUser = true;
    description = "virt example user";
    extraGroups = [ "wheel" ];
  };
}
