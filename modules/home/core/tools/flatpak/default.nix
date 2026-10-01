{
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
    "org.onlyoffice.desktopeditors"
    "io.github.flattool.Warehouse"
  ];

  home.packages = with pkgs; [
    gnome-software
  ];
}
