{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };
  # https://discourse.nixos.org/t/virt-manager-cannot-create-vm/38894/2
  # virt-manager doesn't work without it
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    # same size on wayland and xwayland
    size = 24;
  };
}
