{ lib, pkgs, ... }:
let
  enable = true;
in
{
  programs.ashell = {
    inherit enable;
    settings = {
      position = "Bottom";
      modules = {
        left = [
          "Workspaces"
          "Clock"
        ];
        center = [ "WindowTitle" ];
        right = [
          "Tray"
          "MediaPlayer"
          "Settings"
          "KeyboardSubmap"
        ];
      };
    };
    package = pkgs.ashell;
  };

  systemd = {
    user.services = lib.mkIf enable {
      ashell = {
        Unit = {
          Description = "ashell";
          Documentation = [ "https://malpenzibo.github.io/ashell/docs/intro" ];
        };
        Install = {
          WantedBy = [ "hyprland-session.target" ];
        };
        Service = {
          Type = "exec";
          ExecStart = lib.getExe pkgs.ashell;
          Restart = "on-failure";
          RestartSec = 2;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
