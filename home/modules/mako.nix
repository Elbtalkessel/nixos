{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Only if hyprpanel disabled, they conflic.
  enable = !config.programs.hyprpanel.enable;
in
{
  home.packages = lib.mkIf enable (
    with pkgs;
    [
      libnotify
    ]
  );
  services.mako = {
    inherit enable;
    settings = {
      background-color = "#282828CC";
      text-color = "#ebdbb2";
      border-color = "#32302f";
      progress-color = "over #414559";
      border-radius = "10";
      default-timeout = "5000";
      font = "OverpassM Nerd Font 14";
      "urgency=low" = {
        default-timeout = "2500";
      };
      "urgency=high" = {
        text-color = "#fb4934";
        default-timeout = "0";
      };
    };
  };
}
