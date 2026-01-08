_: {
  xdg.configFile = {
    "hyprpanel/modules.json".text = builtins.toJSON {
      "custom/tray-popup" = {
        icon = "";
        actions = {
          onLeftClick = "eww open tray-popup";
          onRightClick = "eww close tray-popup";
        };
      };
    };
  };
}
