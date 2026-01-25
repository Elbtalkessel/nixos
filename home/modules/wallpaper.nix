{ config, pkgs, ... }:
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
  systemd.user = {
    paths.wallpaper = {
      Unit = {
        Description = "wallpaper file watcher";
        After = [ "hyprpaper.service" ];
        Wants = [ "hyprpaper.service" ];
      };
      Path = {
        PathChanged = config.my.wallpaper.path;
        Unit = "wallpaper.service";
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };
    services.wallpaper = {
      Unit = {
        Description = "wallpaper setter";
        After = [ "hyprpaper.service" ];
        Wants = [ "hyprpaper.service" ];
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
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
  };
}
