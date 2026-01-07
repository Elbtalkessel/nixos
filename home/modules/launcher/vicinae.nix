{ pkgs, lib, ... }:
{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
    };
  };
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/vicinae.nix
  # https://docs.vicinae.com/launcher-window
  # No way to set scaling without custom env.
  systemd.user.services.vicinae.Service.EnvironmentFile = lib.mkForce (
    pkgs.writeText "vicinae-env" ''
      QT_SCALE_FACTOR=1.5
    ''
  );
}
