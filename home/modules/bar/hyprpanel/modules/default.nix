{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (nuenv.writeShellApplication {
      name = "eww-toggle";
      text = builtins.readFile ../../../../bin/eww-toggle.nu;
    })
  ];
  xdg.configFile = {
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
