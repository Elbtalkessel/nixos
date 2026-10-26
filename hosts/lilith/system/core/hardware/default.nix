{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    ./cpu.nix
    ./gpu.nix
    ./peripherals.nix
  ];
}
