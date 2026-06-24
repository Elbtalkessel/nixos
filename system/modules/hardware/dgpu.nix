{
  config,
  lib,
  pkgs,
  ...
}:
let
  # https://wiki.nixos.org/wiki/NVIDIA#Disabling
  gpu = config.my.virt.docker.gpu.enable;
  # https://wiki.nixos.org/wiki/Docker#NVIDIA_Docker_Containers
  cdi = config.my.virt.docker.gpu.enable && gpu;
in
{
  virtualisation = {
    docker = {
      rootless = {
        daemon = {
          settings = {
            features = {
              inherit cdi;
            };
          };
        };
      };
    };
  };

  environment.systemPackages = lib.mkIf cdi [
    pkgs.libnvidia-container
  ];

  boot.blacklistedKernelModules = lib.mkIf (!gpu) [
    "nvidia"
    "nvidiafb"
    "nvidia-drm"
    "nvidia-uvm"
    "nvidia-modeset"
    "nouveau"
  ];

  services.xserver.videoDrivers = lib.mkIf gpu [ "nvidia" ];
  hardware = lib.mkIf gpu {
    nvidia-container-toolkit.enable = cdi;
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
