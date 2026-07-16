{
  config,
  pkgs,
  lib,
  ...
}:
{
  specialisation.nvidia.configuration = (lib.mkIf config.my.hardware.dgpu.enable) {
    virtualisation = {
      docker = {
        rootless = {
          daemon = {
            settings = {
              features = {
                # https://wiki.nixos.org/wiki/Docker#NVIDIA_Docker_Containers
                cdi = config.my.virt.docker.gpu.enable;
              };
            };
          };
        };
      };
    };

    environment.systemPackages = lib.mkIf config.my.virt.docker.gpu.enable [
      pkgs.libnvidia-container
    ];

    boot.blacklistedKernelModules = [ ];

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      nvidia-container-toolkit.enable = config.my.virt.docker.gpu.enable;
      nvidia = {
        open = true;
        # Dynamic Boost balances power between the CPU and the GPU for improved performance on supported laptops using the nvidia-powerd daemon
        dynamicBoost.enable = true;
        prime = {
          amdgpuBusId = "PCI:7:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };
  };
}
