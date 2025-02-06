{ pkgs, ... }:
{
  gtk = {
    enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk2";
    style.package = pkgs.adwaita-qt;
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
