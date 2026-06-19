{
  lib,
  config,
  pkgs,
  ...
}:
let
  palette = config.my.theme.color.dark;
  run = cmd: if config.my.wm.uwsm.enable then "uwsm-app -- ${cmd}" else cmd;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
    # Package and portal is defined in NixOS configuration.
    package = null;
    portalPackage = null;
    systemd = {
      # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#installation
      enable = !config.my.wm.uwsm.enable;
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
          M.eye_candy = ${toString (!config.my.wm.performance)}
          M.swallow = "${config.my.terminal.exe}"
          M.PROG = {
            COLOR_PICKER = "${run (lib.getExe pkgs.hyprpicker)}",
            LAUNCHER = "${run (lib.getExe pkgs.vicinae)}",
            TERMINAL = "${run (lib.getExe config.my.terminal.pkg)}"
          }
          M.ICON = {
            INFO = 1,
            HINT = 2,
            ERROR = 3,
            QUESTION = 4,
            SUCCESS = 5,
          }
          M.COLOR = {
            FG_PRIMARY = "${palette.fg-primary}",
            BG_PRIMARY = "${palette.bg-primary}",
            FG_PRIMARY_CONTAINER = "${palette.fg-primary-container}",
            BG_PRIMARY_CONTAINER = "${palette.bg-primary-container}",
            FG_SECONDARY = "${palette.fg-secondary}",
            BG_SECONDARY = "${palette.bg-secondary}",
            FG_SECONDARY_CONTAINER = "${palette.fg-secondary-container}",
            BG_SECONDARY_CONTAINER = "${palette.bg-secondary-container}",
            FG_TERTIARY = "${palette.fg-tertiary}",
            BG_TERTIARY = "${palette.bg-tertiary}",
            FG_TERTIARY_CONTAINER = "${palette.fg-tertiary-container}",
            BG_TERTIARY_CONTAINER = "${palette.bg-tertiary-container}",
            FG_ERROR = "${palette.fg-error}",
            BG_ERROR = "${palette.bg-error}",
            FG_ERROR_CONTAINER = "${palette.fg-error-container}",
            BG_ERROR_CONTAINER = "${palette.bg-error-container}",
            FG = "${palette.fg}",
            BG = "${palette.bg}",
            FG_SURFACE = "${palette.fg-surface}",
            BG_SURFACE = "${palette.bg-surface}",
          }
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
      "hyprland.10-workspace_rule" = {
        content = ./hyprland/workspace_rule.lua;
        autoLoad = true;
      };
    };
  };
}
