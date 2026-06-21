{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.docker.rootless.daemon.settings.features.cdi = config.my.virt.docker.gpu.enable;
  environment.systemPackages = lib.mkIf config.my.virt.docker.gpu.enable [
    pkgs.libnvidia-container
  ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia-container-toolkit.enable = config.my.virt.docker.gpu.enable;
    nvidia = {
      open = true;
      modesetting.enable = true;
      prime = {
        amdgpuBusId = "PCI:7:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
