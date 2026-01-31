{
  pkgs,
  lib,
  config,
  ...
}:
let
  enable = lib.mkIf config.my.wm.bar.provider == "hyprpanel";

  gst = "graphical-session.target";
  ews = "eww.service";
  hps = "hyprpanel.service";

  eww = pkgs.lib.getExe pkgs.eww;

  # Various approaches to the systemd template services, https://discourse.nixos.org/t/systemd-templates/36356
  tmpl = name: {
    Unit = {
      Description = "wacky ${name} widget";
      Requires = [ ews ];
      After = [ ews ];
    };
    Service = {
      Type = "exec";
      ExecStart = "${eww} open ${name} --no-daemonize";
      ExecStop = "${eww} close ${name}";
      RemainAfterExit = "yes";
      Restart = "on-failure";
      RestartSec = 2;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ gst ];
    };
  };
in
{
  programs.eww = lib.mkIf enable {
    enable = true;
    configDir = ./config;
  };

  systemd = {
    user.services = pkgs.lib.mkIf enable {
      # Main service required for other widgets.
      eww = {
        Unit = {
          Description = "ElKowars wacky widgets";
          Documentation = [ "https://elkowar.github.io/eww/" ];
          PartOf = [ gst ];
        };
        Install = {
          WantedBy = [ gst ];
        };
        Service = {
          Type = "exec";
          ExecStart = "${eww} daemon --no-daemonize";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      # ---

      # System tray widget specifically made for hyperpanel config
      # (see the parent directory) because hyprpanel doesn't support
      # changing tray icon size:
      # https://github.com/Jas-SinghFSU/HyprPanel/issues/540
      eww-tray-inline = pkgs.lib.recursiveUpdate (tmpl "tray-inline") {
        Unit = {
          Requires = [ ews ];
          After = [
            gst
            ews
            hps
          ];
          PartOf = [
            ews
            gst
          ];
        };
        Service = {
          # A little delay before starting to ensure hyprpanel renders first.
          ExecStartPre = "${pkgs.lib.getExe' pkgs.coreutils "sleep"} 2";
        };
      };
      # ---
    };
  };
}
