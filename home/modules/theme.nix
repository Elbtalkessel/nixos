{
  pkgs,
  config,
  lib,
  ...
}:
{
  # Enable GTK theme configuration
  gtk = rec {
    enable = true;
    theme =
      let
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ca/catppuccin-gtk/package.nix#L16
        catover = {
          accents = [ "pink" ];
          size = "compact";
          tweaks = [
            "rimless"
            "float"
          ];
          variant = "mocha";
        };
        _accent = lib.strings.join "," catover.accents;
        _tweaks = lib.strings.join "," catover.tweaks;
        name = "catppuccin-${catover.variant}-${_accent}-${catover.size}+${_tweaks}";
      in
      {
        inherit name;
        package = pkgs.catppuccin-gtk.override catover;
      };
    gtk4.theme = theme;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = config.my.font.family.default;
      size = 14;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
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
