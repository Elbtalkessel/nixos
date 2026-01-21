_: {
  services.flatpak.packages = [
    "app.zen_browser.zen"
    "com.github.tchx84.Flatseal"
    "com.usebottles.bottles"
    "io.github.astralvixen.geforce-infinity"
    "com.plexamp.Plexamp"
  ];

  xdg.desktopEntries = {
    "io.github.astralvixen.geforce-infinity" = {
      name = "Geforce Infinity";
      genericName = "Cloud Gaming";
      exec = "flatpak run io.github.astralvixen.geforce-infinity";
      terminal = false;
      categories = [
        "Game"
        "Network"
      ];
    };
  };
}
