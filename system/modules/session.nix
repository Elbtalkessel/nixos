{ pkgs, ... }:
let
  user = "risus";
in
{
  # Graphical session related, auth, greeter.
  # It is required to enable it to manage system settings, despite it being enabled in the home-manager.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
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
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoLogin.relogin = true;
    };
    # Gretter with autologin
    greetd = {
      enable = false;
      settings = {
        # Passwordless login after boot.
        initial_session = {
          command = "systemctl --user start hyprland";
          inherit user;
        };
        # Regualar login after logout.
        default_session =
          let
            greeter = "${pkgs.greetd.tuigreet}/bin/tuigreet";
          in
          {
            command = "${greeter} --asterisks --remember --remember-user-session --time --cmd 'systemctl --user start hyprland'";
            inherit user;
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
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };
}
