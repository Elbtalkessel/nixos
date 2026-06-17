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
    plugins = [
      (pkgs.callPackage (pkgs.fetchFromGitHub {
        owner = "sandwichfarm";
        repo = "hyprexpo";
        rev = "v0.55.2+2";
        sha256 = "sha256-E+yK/HwvUOrmrFwq/i9WuIpd/NC/qE2xYAwOV2RNp3o=";
      }) { })
    ];
    # References:
    # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/hyprland.nix
    # https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
    # https://wiki.hypr.land/Configuring/Start/
    configType = "lua";
    extraLuaFiles = {
      "hyprland.00-vars" = # lua
        ''
          M = {}
          M.active_border = {
            colors = {
              "${palette.bg-primary}",
              "${palette.bg-primary-container}",
            },
            angle = 90,
          }
          M.inactive_border = {
            colors = {
              "${palette.bg-secondary}11",
              "${palette.bg-secondary-container}11",
            },
            angle = 180,
          }
          M.border_size = 1
          -- it is slightly bigger than waybar has with the same number,
          -- +1 helps.
          M.gap_size = ${toString (config.my.theme.size.edge-gap + 1.0)}
          M.launcher = "${lib.getExe pkgs.vicinae}"
          M.terminal = "${lib.getExe config.my.terminal.pkg}"
          M.eye_candy = ${toString (!config.my.wm.performance)}
          M.swallow = "${config.my.terminal.exe}";
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
      "hyprland.09-hyprexpo" = {
        content = ./hyprland/hyprexpo.lua;
        autoLoad = true;
      };
    };
  };
}
