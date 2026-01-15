{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "setbg" ''
      #!/usr/bin/env sh
      path=$(dconf dump /org/gnome/desktop/background/ | rg "picture-uri='file://([^']+)'$" -or '$1')
      cp -f $1 $path
    '')
  ];
  systemd.user = {
    paths.wallpaper = {
      Unit.Description = "Watches the background file changes";
      Path = {
        PathChanged = config.my.wallpaper;
        Unit = "wallpaper.service";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
    services.wallpaper = {
      Unit.Description = "Calls hyprpaper on background file change.";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "set-wallpaper" ''
          #!/usr/bin/env sh
          path=$(dconf dump /org/gnome/desktop/background/ | rg "picture-uri='file://([^']+)'$" -or '$1')
          hyprctl hyprpaper wallpaper ",$path"
        '';
      };
    };
  };
}
