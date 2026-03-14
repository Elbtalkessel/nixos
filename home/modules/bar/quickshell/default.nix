{
  config,
  lib,
  pkgs,
  ...
}:
let
  enable = config.my.wm.bar.provider == "quickshell";
in
{
  programs.quickshell = lib.mkIf enable {
    systemd = {
      inherit enable;
      target = "hyprland-session.target";
    };
    inherit enable;
  };
  home.packages = lib.mkIf enable [
    pkgs.kdePackages.qt5compat
  ];
}
