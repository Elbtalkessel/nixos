{ pkgs, ... }:
{
  # I can't install them automatically, you'll need manually load these userscripts
  # from the tampermonkey dashboard.
  xdg.configFile = {
    "tampermonkey/userscripts".source = ../config/tampermonkey/userscripts;
  };

  home.packages = with pkgs; [ tor-browser ];

  programs.chromium = {
    enable = true;
  };
}
