{ pkgs, config, ... }:
let
  steam-session-shutdown = (
    pkgs.writeShellScript "steam-session-shutdown" # bash
      ''
        steam -shutdown
        loginctl terminate-user ${config.my.username}
      ''
  );
in
{
  xdg.desktopEntries = {
    "steam-session-shutdown" = {
      name = "Steam Session Shutdown";
      exec = toString steam-session-shutdown;
      terminal = false;
      categories = [
        "Game"
      ];
      icon = "steam";
    };
  };
}
