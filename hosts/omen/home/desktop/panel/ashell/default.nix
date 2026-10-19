{
  config,
  pkgs,
  lib,
  ...
}:
let
  enable = config.my.wm.bar.provider == "ashell";
in
{
  programs.ashell = lib.mkIf enable {
    enable = true;
    settings = {
      position = "Bottom";
      modules = {
        left = [
          "Workspaces"
          "Clock"
        ];
        center = [ "WindowTitle" ];
        right = [
          "SystemInfo"
          [
            "Tray"
            "Privacy"
            "Settings"
          ]
          "KeyboardLayout"
        ];
      };
      workspaces = {
        visibility_mode = "All";
        enable_workspace_filling = true;
        max_workspaces = 10;
      };
      settings = {
        battery_format = "Icon";
        peripheral_battery_format = "Icon";
        peripheral_indicators = {
          Specific = [
            "Gamepad"
            "Keyboard"
          ];
        };
      };
      keyboard_layout = {
        labels = {
          "English (US)" = "🇺🇸";
          "Russian" = "🏳️‍🌈";
          "Italian" = "🇮🇹";
          "Ukranian" = "🇺🇦";
        };
      };
      appearance = {
        font_name = config.my.font.family.default;
        scale_factor = 1.4;
        style = "Solid";
        opacity = 0.8;
        success_color = "#a6e3a1";
        text_color = "#cdd6f4";
        workspace_colors = [
          "#fab387"
          "#b4befe"
          "#cba6f7"
        ];
        menu = {
          opacity = 0.95;
          backdrop = 0.0;
        };
        primary_colors = {
          base = "#fab387";
          text = "#1e1e2e";
        };
        danger_color = {
          base = "#f38ba8";
          weak = "#f9e2af";
        };
        background_color = {
          base = "#1e1e2e";
          weak = "#313244";
          strong = "#45475a";
        };
        secondary_color = {
          base = "#11111b";
          strong = "#1b1b25";
        };
      };
    };
    package = pkgs.ashell;
  };

  systemd = {
    user.services = lib.mkIf enable {
      ashell = {
        Unit = {
          Description = "ashell";
          Documentation = [ "https://malpenzibo.github.io/ashell/docs/intro" ];
        };
        Install = {
          WantedBy = [ "hyprland-session.target" ];
        };
        Service = {
          Type = "exec";
          ExecStart = lib.getExe pkgs.ashell;
          Restart = "on-failure";
          RestartSec = 2;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
