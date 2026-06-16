{
  lib,
  config,
  pkgs,
  ...
}:
let
  palette = config.my.theme.color.dark;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
    package = null;
    portalPackage = null;
    systemd = {
      # Conflicts with UWSM, see system/modules/session.nix
      enable = false;
      # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
      variables = [ "--all" ];
    };
    # References:
    # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/hyprland.nix
    # https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
    # https://wiki.hypr.land/Configuring/Start/
    configType = "lua";
    extraLuaFiles = {
      "hyprland.00-vars" = # lua
        ''
          M = {}
          M.fg_primary = "${lib.strings.removePrefix "#" palette.fg-primary-container}"
          M.fg_secondary = "${lib.strings.removePrefix "#" palette.fg-secondary}"
          M.fg_inactive = "${lib.strings.removePrefix "#" palette.fg}"
          -- it is slightly bigger than waybar has with the same number,
          -- +1 helps.
          M.gap_size = ${toString (config.my.theme.size.edge-gap + 1.0)}
          M.launcher = "${lib.getExe pkgs.vicinae}"
          M.terminal = "${config.my.terminal.exe}"
          M.eye_candy = ${toString (!config.my.wm.performance)}
          return M
        '';
      "hyprland.01-bind" = {
        content = ./hyprland/bind.lua;
        autoLoad = true;
      };
      "hyprland.02-device" = {
        content = ./hyprland/device.lua;
        autoLoad = true;
      };
      "hyprland.03-config" = {
        content = ./hyprland/config.lua;
        autoLoad = true;
      };
      "hyprland.04-event" = {
        content = ./hyprland/event.lua;
        autoLoad = true;
      };
      "hyprland.05-layer" = {
        content = ./hyprland/layer_rule.lua;
        autoLoad = true;
      };
      "hyprland.06-monitor" = {
        content = ./hyprland/monitor.lua;
        autoLoad = true;
      };
      "hyprland.07-window" = {
        content = ./hyprland/window_rule.lua;
        autoLoad = true;
      };
      "hyprland.08-animation" = {
        content = ./hyprland/animation.lua;
        autoLoad = true;
      };
    };
  };
}
