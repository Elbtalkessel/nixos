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
      closeOnFocusLoss = false;
      faviconService = "google";
      font = {
        normal = config.my.font-family;
        size = 10;
      };
      keybindings = "default";
      keybinds = { };

      popToRootOnClose = true;
      rootSearch = {
        searchFiles = true;
      };
      theme = {
        name = "vicinae-dark";
      };
      window = {
        csd = true;
        inherit (config.my) opacity;
        rounding = 10;
      };
    };
  };
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/vicinae.nix
  # https://docs.vicinae.com/launcher-window
  # Settings the layer shell is workaround:
  # https://github.com/vicinaehq/vicinae/issues/398
  # No way to set scaling without custom env.
  systemd.user.services.vicinae.Service.EnvironmentFile = lib.mkForce (
    pkgs.writeText "vicinae-env" ''
      USE_LAYER_SHELL=0
      QT_SCALE_FACTOR=1.5
    ''
  );
  # let hm overwrite the config file if present in .config.
  xdg.configFile."vicinae/vicinae.json".force = true;
}
