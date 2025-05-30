{ pkgs, ... }:
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
    "lf/preview".source = ../config/lf/preview;
    "lf/scope".source = ../config/lf/scope;
  };
}
