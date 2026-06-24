{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    ./cpu.nix
    ./dgpu.nix
    ./igpu.nix
    ./peripherals.nix
    ./printing.nix
  ];
}
