# Values for my.desktop -- see ../options/desktop.nix for the declarations.
{ pkgs, ... }:
let
  inherit (import ./common.nix) userhome;
in
{
  config.my = {
    wallpaper = {
      path = "${userhome}/.config/background";
      source = "${userhome}/Pictures/Wallpaper";
      random.timer = "3m";
      random.enable = false;
      cmd.set = "set-wallpaper";
    };

    terminal = {
      pkg = pkgs.foot;
      desktop = "foot.desktop";
      exe = "foot";
      font-size = 14;
    };

    opacity = 0.85;

    wm = {
      uwsm.enable = true;
      performance = false;
      bar.provider = "noctalia";
    };
  };
}
