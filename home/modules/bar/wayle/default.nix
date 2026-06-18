_: {
  imports = [
    ./settings/bar.nix
    ./settings/general.nix
    ./settings/modules.nix
    ./settings/osd.nix
    ./settings/styling.nix
    ./settings/wallpaper.nix
  ];
  services.wayle = {
    enable = true;
  };
}
