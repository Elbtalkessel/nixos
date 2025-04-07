{ nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-gpu-nvidia
  ];
  hardware = {
    nvidia = {
      open = false;
      prime = {
        amdgpuBusId = "PCI:7:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
