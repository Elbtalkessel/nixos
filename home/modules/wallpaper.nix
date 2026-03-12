{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    (writeShellScriptBin config.my.wallpaper.cmd.get ''
      #!/usr/bin/env sh
      echo $(dconf dump /org/gnome/desktop/background/ | rg "picture-uri='file://([^']+)'$" -or '$1')
    '')
    (writeShellScriptBin config.my.wallpaper.cmd.set ''
      #!/usr/bin/env sh
      if test -z "$1"; then
        echo "missing wallpaper path" >&2
        exit 1
      fi
      cp -f "$1" $(get-wallpaper)
    '')
  ];
  systemd.user =
    let
      unit =
        override:
        (
          {
            After = [ "hyprpaper.service" ];
            Wants = [ "hyprpaper.service" ];
          }
          // override
        );
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    in
    {
      # paths
      paths = {
        wallpaper = {
          inherit Install;
          Unit = unit {
            Description = "wallpaper file watcher";
          };
          Path = {
            PathChanged = config.my.wallpaper.path;
            Unit = "wallpaper.service";
          };
        };
      };
      # ---

      # services
      services = {
        wallpaper = {
          inherit Install;
          Unit = unit {
            Description = "wallpaper setter";
          };
          Service = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "apply-wallpaper" ''
              #!/usr/bin/env sh
              hyprctl hyprpaper wallpaper ",`${config.my.wallpaper.cmd.get}`"
            '';
            Restart = "on-failure";
            RestartSec = 2;
            TimeoutStopSec = 10;
          };
        };
        rnd-wallpaper = lib.mkIf (config.my.wallpaper.random.path != "") {
          inherit Install;
          Unit = unit {
            Description = "sets a random wallpaper";
          };
          Service = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "rnd-wallpaper" ''
              #!/usr/bin/env sh
              p=${config.my.wallpaper.random.path}
              if ! test -d $p; then
                exit 0
              fi
              f=$(find $p -type f -name '*.jpg' -or -name '*.png' | shuf | head -1)
              if ! test -f $f; then
                exit 0
              fi
              ${config.my.wallpaper.cmd.set} "$f"
            '';
            Restart = "on-failure";
            RestartSec = 2;
            TimeoutStopSec = 10;
          };
        };
      };
      # ---

      # timers
      timers = {
        rnd-wallpaper =
          lib.mkIf (config.my.wallpaper.random.timer != "" && config.my.wallpaper.random.path != "")
            {
              inherit Install;
              Unit = unit {
                Description = "Sets a random wallpaper periodically";
              };
              Timer = {
                OnBootSec = "5s";
                OnUnitActiveSec = config.my.wallpaper.random.timer;
                Unit = "rnd-wallpaper";
              };
            };
      };
      # ---

    };
}
