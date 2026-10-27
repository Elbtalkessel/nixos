# Hyprland session lifecycle: the systemd service/target pair that ties the
# compositor to `graphical-session.target`, and the UWSM environment hook.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#nixos-uwsm
  xdg.configFile."uwsm/env" = lib.mkIf config.my.desktop.manager.uwsm.enable {
    source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };

  home.packages = with pkgs; [
    hyprshutdown
  ];

  systemd.user = {
    services = {
      hyprland-session = {
        Unit = {
          Description = "Hyprland session";
          PartOf = [ "hyprland-session.target" ];
          Wants = [ "hyprland-session.target" ];
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = lib.getExe' pkgs.coreutils "true";
        };
      };
    };

    targets = {
      hyprland-session = {
        Unit = {
          Description = "Hyprland session";
          BindsTo = "graphical-session.target";
          Before = "graphical-session.target";
          DefaultDependencies = "no";
          RefuseManualStart = "yes";
          RefuseManualStop = "yes";
          Requires = "basic.target";
          StopWhenUnneeded = "yes";
        };
      };
    };
  };
}
