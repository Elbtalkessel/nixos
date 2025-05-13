{ pkgs, ... }:
{
  # I can't install them automatically, you'll need manually load these userscripts
  # from the tampermonkey dashboard.
  xdg.configFile = {
    "tampermonkey/userscripts".source = ../config/tampermonkey/userscripts;
  };

  home.packages = with pkgs; [ tor-browser-bundle-bin ];

  programs.chromium = {
    enable = true;
    package = pkgs.vivaldi;
    extensions = [
      # Vimium
      # https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }

      # Proton Pass
      # https://chromewebstore.google.com/detail/proton-pass-free-password/ghmbeldphafepmbegfdlkpapadhbakde
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; }

      # JetBrains Grazie
      # https://chromewebstore.google.com/detail/jetbrains-grazie-ai-writi/fonaoompfjljjllgccccgjnhnoghohgc
      { id = "fonaoompfjljjllgccccgjnhnoghohgc"; }

      # Page assist (Web UI for local AI)
      # https://chromewebstore.google.com/detail/page-assist-a-web-ui-for/jfgfiigpkhlkbnfnbobbkinehhfdhndo
      { id = "jfgfiigpkhlkbnfnbobbkinehhfdhndo"; }

      # Tampermonkey
      # https://chromewebstore.google.com/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo
      { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; }
    ];
  };
}
