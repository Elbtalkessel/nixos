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
        normal = {
          family = config.my.font.family.default;
          size = 11;
        };
        rendering = "qt";
      };
      launcher_window = {
        opacity = 0.9;
      };
      providers = {
        power = {
          entrypoints =
            let
              hyprshutdown = lib.getExe pkgs.hyprshutdown;
              run = cmd: if config.my.wm.uwsm.enable then "uwsm app -- ${cmd}" else cmd;
            in
            {
              logout = {
                preferences = {
                  confirm = true;
                  customProgram = run "${hyprshutdown} -t 'Logging out...'";
                };
              };
              power-off = {
                preferences = {
                  confirm = true;
                  customProgram = run "${hyprshutdown} -t 'Shutting down...' --post-cmd 'shutdown -P now'";
                };
              };
              reboot = {
                preferences = {
                  confirm = true;
                  customProgram = run "${hyprshutdown} -t 'Restarting...' --post-cmd 'reboot'";
                };
              };
            };
        };
      };
      theme = {
        dark = {
          icon_theme = "Adwaita";
          name = "kanagawa";
        };
      };
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
