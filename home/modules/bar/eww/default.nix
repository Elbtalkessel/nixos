{ pkgs, ... }:
let
  enable = true;
  service = true;
in
{
  programs.eww = {
    inherit enable;
    configDir = ./config;
  };

  systemd =
    let
      eww = pkgs.lib.getExe pkgs.eww;
      # Various approaches to the systemd template services, https://discourse.nixos.org/t/systemd-templates/36356
      tmpl = name: {
        Unit = {
          Description = "ElKowars wacky ${name} widget";
          Documentation = [ "https://elkowar.github.io/eww/" ];
          Requires = [ "eww.service" ];
          After = [ "eww.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${eww} open --no-daemonize ${name}";
          ExecStop = "${eww} close --no-daemonize ${name}";
          RemainAfterExit = "yes";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    in
    {
      user.services = pkgs.lib.mkIf (enable && service) {
        eww = {
          Unit = {
            Description = "ElKowars wacky widgets";
            Documentation = [ "https://elkowar.github.io/eww/" ];
            PartOf = [ "graphical-session.target" ];
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
          Service = {
            Type = "exec";
            ExecStart = "${eww} daemon --no-daemonize";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
        # System tray widget specifically made for hyperpanel config
        # (see the parent directory) because hyprpanel doesn't support
        # changing tray icon size:
        # https://github.com/Jas-SinghFSU/HyprPanel/issues/540
        eww-tray-inline = pkgs.lib.recursiveUpdate (tmpl "tray-inline") {
          Unit = rec {
            After = [
              "eww.service"
              "hyprpanel.service"
            ];
            Requires = After;
            PartOf = [ "hyprpanel.service" ];
          };
          Service = {
            # A little delay before starting to ensure hyprpanel renders first.
            ExecStartPre = "${pkgs.lib.getExe' pkgs.coreutils "sleep"} 1";
          };
        };
      };
    };
}
