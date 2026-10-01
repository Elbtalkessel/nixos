{
  noctalia,
  config,
  pkgs,
  lib,
  ...
}:
let
  enable = config.my.wm.bar.provider == "noctalia";
in
{
  imports = [
    noctalia.homeModules.default
  ];
  programs.noctalia = {
    inherit enable;
  };
  home.packages = lib.mkIf enable (
    with pkgs;
    [
      ddcutil
    ]
  );
}
