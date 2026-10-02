{
  lib,
  config,
  ...
}:
{
  # modules/home/desktop/session/hyprlock.nix
  # https://mynixos.com/home-manager/option/programs.hyprlock.enable
  security.pam.services.hyprlock = lib.mkIf (config.my.wm.bar.provider != "noctalia") { };
}
