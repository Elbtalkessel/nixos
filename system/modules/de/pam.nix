{
  lib,
  config,
  ...
}:
{
  security = lib.mkIf (config.my.wm.bar.provider != "noctalia") {
    # See:
    #   home/modules/hyprland.nix (hyprlock)
    #   https://mynixos.com/home-manager/option/programs.hyprlock.enable
    pam.services.hyprlock = { };
  };
}
