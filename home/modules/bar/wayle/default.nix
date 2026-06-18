{ config, ... }:
let
  enable = config.my.wm.bar.provider == "wayle";
in
{
  imports = [
    ./settings/bar.nix
    ./settings/general.nix
    ./settings/modules.nix
    ./settings/osd.nix
    ./settings/styling.nix
    ./settings/wallpaper.nix
  ];
  services.wayle = {
    inherit enable;
  };
}
