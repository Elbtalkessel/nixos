{ nixos-hardware, config, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-gpu-nvidia
  ];
  virtualisation.docker.rootless.daemon.settings.features.cdi = config.my.virt.docker.gpu.enable;
  hardware = {
    nvidia-container-toolkit.enable = config.my.virt.docker.gpu.enable;
    nvidia = {
      open = false;
      prime = {
        amdgpuBusId = "PCI:7:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
