{ pkgs, ... }:
{
  programs = {
    mpv = {
      enable = true;
      package = pkgs.mpv.override {
        # Depends on yt-dlp, in turn it depends on deno
        # at time fixing it deno was missing from Hydra, compiling it takes
        # too long.
        youtubeSupport = false;
      };
      config = {
        # Issue: https://github.com/mpv-player/mpv/issues/13019
        # Long startup using vulkan.
        gpu-api = "opengl";
        loop-file = "inf";
      };
    };
  };
}
