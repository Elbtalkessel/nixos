{ pkgs, lib, ... }:
rec {
  # Graphical session related, auth, greeter.
  # It is required to enable it to manage system settings, despite it being enabled in the home-manager.
  programs.hyprland = {
    enable = true;
    withUWSM = programs.uwsm.enable;
  };

  programs.uwsm.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    greetd = {
      enable = true;
      settings =
        let
          cmd = if programs.uwsm.enable then "uwsm start hyprland-uwsm.desktop" else "Hyprland";
        in
        {
          initial_session = {
            command = cmd;
            # TODO(conf): a central point to define default username.
            user = "risus";
          };
          default_session = {
            command = "${lib.getExe pkgs.greetd.tuigreet} --asterisks --remember --time --cmd '${cmd}'";
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
    enable = true;
    mime.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };
}
