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

    # DEBUG: Keep PCI active, on current hardware I observed:
    # When gpu transition to inactive
    # and several minutes passes
    # Then system shutdowns, no panic, no nothing, just shutdown.
    # Temporary udev rule to confirm theory.
    # /sys/bus/pci/devices/0000:01:00.0/power/runtime_status
    # /sys/bus/pci/devices/0000:01:00.0/power/runtime_active_time;
    # /sys/bus/pci/devices/0000:01:00.0/power/runtime_suspended_time
    # /sys/bus/pci/devices/0000:01:00.0/current_link_speed (will wakeup gpu)
    # /sys/bus/pci/devices/0000:01:00.0/current_link_width (will wakeup gpu)
    # /sys/bus/pci/devices/0000:01:00.0/power/runtime_usage
    # /proc/driver/nvidia/params
    # echo auto | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control
    systemd.services.nvidia-runtime-pm-off = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c 'echo on > /sys/bus/pci/devices/0000:01:00.0/power/control'";
      };
    };
  };
}
