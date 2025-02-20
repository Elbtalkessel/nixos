{
  pkgs,
  lib,
  config,
  ...
}:
let
  sep = "  ";
  lpad = v: if lib.stringLength v > 0 then sep + v else v;
in
{
  programs.waybar = {
    enable = true;
    systemd = lib.mkIf config.wayland.windowManager.hyprland.systemd.enable {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = [
      {
        "layer" = "top";
        "position" = "top";
        "mode" = "dock";
        "exclusive" = true;
        "passthrough" = false;
        "gtk-layer-shell" = true;
        "height" = 0;
        "margin-top" = 5;
        "margin-left" = 5;
        "margin-right" = 5;
        "margin-bottom" = 3;
        "modules-left" = [
          "custom/powermenu"
          "custom/sep"
          "hyprland/workspaces"
        ];
        "modules-center" = [
          "hyprland/window"
        ];
        "modules-right" = [
          "tray"
          "custom/sep"
          "pulseaudio"
          "mpd"
          "custom/sep"
          "network"
          # these may or may not be visible, separator is inside these.
          "bluetooth"
          "battery"
          "backlight"
          # ---
          "custom/sep"
          "clock"
          "custom/sep"
          "hyprland/language"
        ];
        "hyprland/window" = import ./window.nix { };
        "hyprland/workspaces" = import ./workspaces.nix { };
        "hyprland/language" = import ./language.nix { };
        "tray" = import ./tray.nix { };
        "bluetooth" = import ./bluetooth.nix { inherit lib lpad; };
        "network" = import ./network.nix { };
        "pulseaudio" = import ./pulseaudio.nix { inherit lib; };
        "clock" = import ./clock.nix { };
        "battery" = import ./battery.nix { inherit lib lpad; };
        "backlight" = import ./backlight.nix { inherit lib lpad; };
        "custom/sep" = import ./sep.nix { inherit sep; };
        "mpd" = import ./mpd.nix { };
        "custom/powermenu" = import ./powermenu.nix { inherit pkgs; };
      }
    ];

    style = import ./style.nix { };
  };
}
