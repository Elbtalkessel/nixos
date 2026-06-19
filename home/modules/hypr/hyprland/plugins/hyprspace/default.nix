{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprspace
    ];
    extraLuaFiles = {
      "hyprland.101-hyprspace" = {
        content = ./hyprspace.lua;
        autoLoad = true;
      };
    };
  };
}
