{
  lib,
  config,
  pkgs,
  ...
}:
let
  command = (
    if config.programs.uwsm.enable then "uwsm start hyprland-uwsm.desktop" else "start-hyprland"
  );
  tui = false;
in
{
  programs.regreet = {
    enable = !tui;
    theme = {
      name = "Adwaita-dark";
    };
  };

  services = {
    greetd = {
      enable = lib.mkDefault true;
      useTextGreeter = tui;
      settings = {
        initial_session = {
          inherit command;
          user = config.my.username;
        };
        # For regreet documentation recommends a minimal hyprland
        # config from withing which regreet is started, but default nix
        # configuration works just fine.
        # I've tried to follow documentation, it didn't work.
        default_session = lib.mkIf tui {
          command = "${lib.getExe pkgs.tuigreet} --asterisks --remember --time --cmd '${command}'";
        };
      };
    };
  };
}
