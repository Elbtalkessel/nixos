{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Graphical session related, auth, greeter.
  # It is required to enable it to manage system settings, despite it being enabled in the home-manager.
  programs.hyprland = {
    enable = true;
    withUWSM = config.my.wm.uwsm.enable;
  };

  programs.uwsm.enable = config.my.wm.uwsm.enable;

  services = {
    greetd = {
      enable = lib.mkDefault true;
      settings =
        let
          cmd = if config.my.wm.uwsm.enable then "uwsm start hyprland-uwsm.desktop" else "start-hyprland";
        in
        {
          initial_session = {
            command = cmd;
            user = config.my.username;
          };
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --asterisks --remember --time --cmd '${cmd}'";
          };
        };
    };
  };

  security = {
    # See:
    #   home/modules/hyprland.nix (hyprlock)
    #   https://mynixos.com/home-manager/option/programs.hyprlock.enable
    pam.services.hyprlock = { };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "hyprland" ];
        };
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
        };
      };
    };
  };
}
