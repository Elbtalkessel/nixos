{ config, ... }:
{
  services.flatpak.packages = [
    "io.github.astralvixen.geforce-infinity"
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
      icon = "${config.my.theme.icon.path}/apps/geforcenow.svg";
    };
  };
}
