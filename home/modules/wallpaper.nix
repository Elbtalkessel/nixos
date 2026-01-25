{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "get-wallpaper" ''
      #!/usr/bin/env sh
      echo $(dconf dump /org/gnome/desktop/background/ | rg "picture-uri='file://([^']+)'$" -or '$1')
    '')
    (writeShellScriptBin "set-wallpaper" ''
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
      Unit.Description = "wallpaper file watcher";
      Path = {
        PathChanged = config.my.wallpaper;
        Unit = "wallpaper.service";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
    services.wallpaper = {
      Unit.Description = "wallpaper setter";
      Unit.After = [ "hyprpaper.service" ];
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "apply-wallpaper" ''
          #!/usr/bin/env sh
          hyprctl hyprpaper wallpaper ",$(get-wallpaper)"
        '';
      };
    };
  };
}
