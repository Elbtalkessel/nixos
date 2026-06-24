{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  hardware = {
    cpu.amd.updateMicrocode = true;
  };
}
