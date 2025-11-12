{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
    };
    settings = {
      font = {
        normal = config.my.font-family;
        size = 10;
      };
      keybindings = "default";
      window = {
        csd = true;
        inherit (config.my) opacity;
      };
    };
  };
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/vicinae.nix
  # https://docs.vicinae.com/launcher-window
  systemd.user.services.vicinae.Service.EnvironmentFile = lib.mkForce (
    pkgs.writeText "vicinae-env" ''
      USE_LAYER_SHELL=1
      QT_SCALE_FACTOR=1.5
    ''
  );
}
