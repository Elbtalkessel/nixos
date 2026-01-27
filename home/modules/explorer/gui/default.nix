{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Sometimes drag-n-drop is only option.
    nautilus
    # Image organizer.
    shotwell
  ];
}
