_: {
  # I can't install them automatically, you'll need manually load these userscripts
  # from the tampermonkey dashboard.
  xdg.configFile = {
    "tampermonkey/userscripts".source = ./config/tampermonkey/userscripts;
  };
  services.flatpak.packages = [
    "app.zen_browser.zen"
  ];
}
