{
  pkgs,
  lib,
  config,
  ...
}:
let
  sep = "  ";
  lpad = v: if lib.stringLength v > 0 then sep + v else v;
  enable = config.my.wm.bar.provider == "waybar";
in
{
  programs.waybar = lib.mkIf enable {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
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
          "custom/sep"
        ];
        "modules-center" = [
          "hyprland/window"
        ];
        "modules-right" = [
          "tray"
          "custom/sep"
          "pulseaudio"
          # "mpd"
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
        "hyprland/window" = import ./modules/window.nix { };
        "hyprland/workspaces" = import ./modules/workspaces.nix { };
        "hyprland/language" = import ./modules/language.nix { };
        "tray" = import ./modules/tray.nix { };
        "bluetooth" = import ./modules/bluetooth.nix { inherit lib lpad; };
        "network" = import ./modules/network.nix { };
        "pulseaudio" = import ./modules/pulseaudio.nix { inherit lib; };
        "clock" = import ./modules/clock.nix { };
        "battery" = import ./modules/battery.nix { inherit lib lpad; };
        "backlight" = import ./modules/backlight.nix { inherit lib lpad; };
        "custom/sep" = import ./modules/sep.nix { inherit sep; };
        "mpd" = import ./modules/mpd.nix { };
        "custom/powermenu" = import ./modules/powermenu.nix { inherit pkgs; };
      }
    ];
  };
}
