# A deliberately minimal example host.
#
# It imports nothing from `modules/system/`: those modules are written against
# omen's hardware, so sharing them would drag that hardware along. This host
# stays self-contained until the hardware-agnostic parts are split out.
#
# What it is for: showing the shape of a host entrypoint -- an import list,
# host identity, a state version -- and nothing more.
{
  lib,
  config,
  ...
}:
{
  imports = [ ./disko.nix ];

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
