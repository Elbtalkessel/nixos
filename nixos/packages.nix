{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override{ fonts = ["JetBrainsMono"]; })
  ];
}
