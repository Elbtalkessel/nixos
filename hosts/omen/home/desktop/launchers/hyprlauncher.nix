{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    hyprlauncher
  ];

  xdg.configFile = {
    "hypr/hyprlauncher.conf".text = ''

    '';
  };

  systemd.user.services.hyprlauncher = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.hyprlauncher} -d";
      Slice = [ "session.slice" ];
      Restart = "on-failure";
    };
    Unit = {
      Description = "Multipurpose and versatile launcher / picker for hyprland";
      Documentation = "https://wiki.hypr.land/Hypr-Ecosystem/hyprlauncher/";
      PartOf = [ "graphical-session.target" ];
      Requires = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
  };

}
