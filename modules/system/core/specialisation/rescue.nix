_: {
  specialisation = {
    # Minimal configuration for system rescue, to be expanded...
    rescue.configuration = {
      boot = {
        blacklistedKernelModules = [
          "nouveau"
          "nvidia"
          "nvidia_drm"
          "nvidia_modeset"
          "nvidia_uvm"
          "amdgpu"
        ];
        initrd.kernelModules = [ ];
        kernelParams = [
          "nvidia-drm.modeset=0"
          "nvidia-drm.fbdev=0"
        ];
      };

      hardware = {
        graphics.enable = false;
        graphics.enable32Bit = false;
        steam-hardware.enable = false;
      };

      programs = {
        # steam module enables graphics.
        steam.enable = false;
      };

      services = {
        greetd.enable = false;
        xserver.videoDrivers = [ "modesetting" ];
      };
    };
  };
}
