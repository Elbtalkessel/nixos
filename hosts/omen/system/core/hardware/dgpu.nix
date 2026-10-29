{
  lib,
  pkgs,
  config,
  ...
}:
let
  enable = config.my.core.hardware.dgpu.enable;
  docker-enable = enable && config.my.core.virt.docker.gpu.enable;
in
{
  # Top level, deliberately: a specialisation is evaluated with `extendModules`,
  # which carries over the parent's module *definitions* but nothing an
  # evaluation already happened to compute. An allowlist nested inside
  # `specialisation.nvidia.configuration` below would apply to the nested tree
  # and never reach the drivers it is meant to cover.
  nixpkgs.config.allowUnfreePackages = [
    "nvidia-kernel-modules"
    "nvidia-settings"
    "nvidia-x11"
  ];

  # https://wiki.nixos.org/wiki/Docker#NVIDIA_Docker_Containers
  virtualisation = lib.mkIf docker-enable {
    docker = {
      rootless = {
        daemon = {
          settings = {
            features = {
              cdi = true;
            };
          };
        };
      };
    };
  };

  environment.systemPackages = lib.mkIf docker-enable [
    pkgs.libnvidia-container
  ];

  services.xserver.videoDrivers = lib.mkIf enable [ "nvidia" ];
  hardware = lib.mkIf enable {
    nvidia-container-toolkit.enable = docker-enable;
    nvidia = {
      open = true;
      # Dynamic Boost balances power between the CPU and the GPU for improved performance on supported laptops using the nvidia-powerd daemon
      dynamicBoost.enable = true;
      powerManagement.enable = true;
      prime = {
        amdgpuBusId = "PCI:7:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Keep PCI active, on current hardware I observed:
  # When gpu transition to inactive
  # and several minutes passes
  # Then system shutdowns, no panic, no nothing, just shutdown.
  # Yet to confirm: I had shutdown on default profile, with nvidia
  # GPU drivers blacklisted. Moved the rule here from nvidia.nix
  #
  # Devices useful for debugging:
  # /sys/bus/pci/devices/0000:01:00.0/power/runtime_status
  # /sys/bus/pci/devices/0000:01:00.0/power/runtime_active_time;
  # /sys/bus/pci/devices/0000:01:00.0/power/runtime_suspended_time
  # /sys/bus/pci/devices/0000:01:00.0/current_link_speed (will wakeup gpu)
  # /sys/bus/pci/devices/0000:01:00.0/current_link_width (will wakeup gpu)
  # /sys/bus/pci/devices/0000:01:00.0/power/runtime_usage
  # /proc/driver/nvidia/params
  #
  # Restore default behaviour:
  # echo auto | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control
  systemd.services.nvidia-runtime-pm-off = lib.mkIf enable {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo on > /sys/bus/pci/devices/0000:01:00.0/power/control'";
    };
  };
}
