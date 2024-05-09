{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
    nodejs
    pre-commit
    (python3.withPackages (_: [ pre-commit ]))
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override{ fonts = ["JetBrainsMono"]; })
  ];
}
