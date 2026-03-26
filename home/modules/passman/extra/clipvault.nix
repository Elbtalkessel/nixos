{ pkgs }:
# Not used at the moment, leaving as a reference just in case.
pkgs.writeShellApplication {
  name = "clipvault";
  text = ./clipvault.nu;
  runtimeInputs = with pkgs; [
    yad
    bitwarden-cli
    ripgrep
    wl-clipboard-rs
    tofi
    libnotify
  ];
}
