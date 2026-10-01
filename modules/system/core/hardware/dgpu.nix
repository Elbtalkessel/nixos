{ lib, pkgs, ... }:
{
  boot.blacklistedKernelModules = lib.mkDefault [
    "nvidia"
    "nvidiafb"
    "nvidia-drm"
    "nvidia-uvm"
    "nvidia-modeset"
    "nouveau"
  ];

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
  systemd.services.nvidia-runtime-pm-off = {
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo on > /sys/bus/pci/devices/0000:01:00.0/power/control'";
    };
  };
}
