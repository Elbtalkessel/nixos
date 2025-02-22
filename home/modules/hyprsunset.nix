{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    hyprsunset
  ];
  # wayland.windowManager.hyprland.settings.exec-once = [
  #   (lib.getExe pkgs.hyprsunset)
  # ];
  #
  # IPC doesn't work :(
  systemd.user.services.hyprsunset = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.hyprsunset} -t 4500";
      Slice = [ "session.slice" ];
      Restart = "on-failure";
    };
    Unit = {
      Description = "An application to enable a blue-light filter on Hyprland.";
      Documentation = "https://wiki.hyprland.org/Hypr-Ecosystem/hyprsunset/";
      PartOf = [ "graphical-session.target" ];
      Requires = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
  };
}
