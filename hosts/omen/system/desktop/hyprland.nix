{ config, ... }: {
  # It is required to enable it to manage system settings, despite it being enabled in the home-manager.
  programs.hyprland = {
    enable = true;
    withUWSM = config.my.desktop.manager.uwsm.enable;
  };

  programs.uwsm.enable = config.my.desktop.manager.uwsm.enable;
}
