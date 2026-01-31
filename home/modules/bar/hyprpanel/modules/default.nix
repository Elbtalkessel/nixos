{
  pkgs,
  lib,
  config,
  ...
}:
let
  enable = lib.mkIf config.my.wm.bar.provider == "hyprpanel";
in
{
  home.packages = lib.mkIf enable (
    with pkgs;
    [
      (nuenv.writeShellApplication {
        name = "eww-toggle";
        text = builtins.readFile ../../../../bin/eww-toggle.nu;
      })
    ]
  );
  xdg.configFile = lib.mkIf enable {
    "hyprpanel/modules.json".text = builtins.toJSON {
      "custom/tray-popup" = {
        icon = "";
        actions = {
          onLeftClick = "eww-toggle tray-popup";
        };
      };
    };
  };
}
