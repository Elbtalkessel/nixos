_: {
  programs = {
    mpv = {
      enable = true;
      config = {
        # Issue: https://github.com/mpv-player/mpv/issues/13019
        # Long startup using vulkan.
        gpu-api = "opengl";
        loop-file = "inf";
      };
    };
  };
}
