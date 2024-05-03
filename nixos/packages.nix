{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    lf
    lunarvim
    lazygit
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override{ fonts = ["JetBrainsMono"]; })
  ];
}
