{ pkgs, ... }:
let
  bitwarden-nu-menu = pkgs.writeShellApplication {
    name = "bw-menu.nu";
    text = ../bin/bw-menu.nu;
    runtimeInputs = with pkgs; [
      yad
      bitwarden-cli
      ripgrep
      wl-clipboard-rs
      tofi
      libnotify
    ];
  };
in
{
  home.packages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli
    bitwarden-nu-menu
  ];
}
