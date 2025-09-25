{ pkgs, lib, ... }:
{
  programs.lf = {
    enable = true;
  };

  # requires fzf
  xdg.configFile = {
    "lf/lfrc".source = ../config/lf/lfrc;
    "lf/preview".source = lib.getExe pkgs.lf-tools.preview;
  };
}
