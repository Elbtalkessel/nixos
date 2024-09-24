_: {
  programs.lf = {
    enable = true;
  };

  # requires fzf
  xdg.configFile = {
    "lf/lfrc".source = ../config/lf/lfrc;
    "lf/preview".source = ../config/lf/preview;
    "lf/scope".source = ../config/lf/scope;
    "fish/completions/lf.fish".source = ../config/lf/lf.fish;
    "fish/functions/lfcd.fish".source = ../config/lf/lfcd.fish;
  };
}
