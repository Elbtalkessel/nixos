{
  config,
  nix-flatpak,
  pkgs,
  ...
}:
{
  imports = [
    nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
    "com.usebottles.bottles"
    "io.github.astralvixen.geforce-infinity"
    "com.plexamp.Plexamp"
    "org.onlyoffice.desktopeditors"
    "io.github.flattool.Warehouse"
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

  home.packages = with pkgs; [
    gnome-software
  ];
}
