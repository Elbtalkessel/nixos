{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Enable GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Orange-Darkest-Solid";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "OverpassM Nerd Font 14";
      size = 14;
    };
  };

  # Enable Qt theme configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # Configure GNOME settings for dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
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
