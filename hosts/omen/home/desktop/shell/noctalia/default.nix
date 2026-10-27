{
  noctalia,
  config,
  pkgs,
  lib,
  ...
}:
let
  enable = config.my.desktop.shell.provider == "noctalia";
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
