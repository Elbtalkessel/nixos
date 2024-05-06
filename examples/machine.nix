# Machine specific configuration (minus hardware-configuration.nix)

{ ... }:
{
  networking.hostName = "l440"; # Define your hostname.

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdc";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-291542ea-4836-4ea3-bcec-095490c2c3a0".device = "/dev/disk/by-uuid/291542ea-4836-4ea3-bcec-095490c2c3a0";
  boot.initrd.luks.devices."luks-c93bba6c-41b5-430e-9c6d-fc2c3665b382".device = "/dev/disk/by-uuid/c93bba6c-41b5-430e-9c6d-fc2c3665b382";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };
  boot.loader.grub.enableCryptodisk=true;
  boot.initrd.luks.devices."luks-291542ea-4836-4ea3-bcec-095490c2c3a0".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-c93bba6c-41b5-430e-9c6d-fc2c3665b382".keyFile = "/crypto_keyfile.bin";


}
