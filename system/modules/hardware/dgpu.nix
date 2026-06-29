{ lib, ... }:
{
  boot.blacklistedKernelModules = lib.mkDefault [
    "nvidia"
    "nvidiafb"
    "nvidia-drm"
    "nvidia-uvm"
    "nvidia-modeset"
    "nouveau"
  ];
}
