{ pkgs, ... }: {
  programs.lf = {
    enable = true;
  };
  
  # requires fzf
  xdg.configFile."lf/lfrc".source = ../config/lf/lfrc;
  xdg.configFile."lf/preview".source = ../config/lf/preview;
  xdg.configFile."lf/scope".source = ../config/lf/scope;
  xdg.configFile."fish/completions/lf.fish".source = ../config/lf/lf.fish;
  xdg.configFile."fish/functions/lfcd.fish".source = ../config/lf/lfcd.fish;
}
