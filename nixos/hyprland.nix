{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  programs.waybar = {
    enable = true;
  };

  users.users.risus.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
    tofi
  ];

  services.gnome.gnome-keyring.enable = true;
}
