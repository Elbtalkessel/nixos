{ lib, ... }:
{
  specialisation.rescue.configuration = {
    # Boot to a multi-user console, not a graphical session.
    systemd.defaultUnit = lib.mkForce "multi-user.target";

    services = {
      xserver.enable = lib.mkForce false;
      xserver.videoDrivers = lib.mkForce [ ];
    };

    # Disable graphics userspace.
    hardware = {
      graphics = {
        enable = lib.mkForce false;
        enable32Bit = lib.mkForce false;
      };
      # Explicitly override inherited NVIDIA configuration.
      nvidia = {
        open = lib.mkForce false;
        dynamicBoost.enable = lib.mkForce false;
        powerManagement.enable = lib.mkForce false;
      };
      nvidia-container-toolkit.enable = lib.mkForce false;
    };

    boot = {
      # Prevent NVIDIA and Nouveau from loading.
      blacklistedKernelModules = [
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia_uvm"
        "nouveau"
      ];

      # These parameters are harmless when the NVIDIA DRM module is absent,
      # and make the intended rescue configuration explicit.
      kernelParams = [
        "nvidia-drm.modeset=0"
        "nvidia-drm.fbdev=0"
      ];
    };

    # Don't run the workaround service in rescue mode.
    systemd.services.nvidia-runtime-pm-off.enable = lib.mkForce false;
  };
}
