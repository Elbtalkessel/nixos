{ config, ... }: {
  # It is required to enable it to manage system settings, despite it being enabled in the home-manager.
  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = config.programs.uwsm.enable;
  };
}
