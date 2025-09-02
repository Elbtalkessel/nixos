{ pkgs, lib, ... }:
let
  lfextra = import ../../packages/lf { inherit pkgs; };
in
{
  programs.lf = {
    enable = true;
  };

  home.packages = with pkgs; [
    # Required to extract mime-type to handle a file or directory
    file
  ];

  # requires fzf
  xdg.configFile = {
    "lf/lfrc".source = ../config/lf/lfrc;
    # getting exe from import seems somewhat wrong
    "lf/preview".source = lib.getExe lfextra.preview;
    "lf/scope".source = ../config/lf/scope;
  };
}
