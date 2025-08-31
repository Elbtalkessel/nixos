{ pkgs, ... }:
let
  # writeShellScriptBin doesn't work, nix complains about wrong syntax.
  # llm told me the command supports only POSIX complaint scripts,
  # I have no idea if this is true.
  # TODO: move it to my nix pkgs repo.
  bitwarden-nu-menu = pkgs.stdenv.mkDerivation {
    name = "bw-menu.nu";
    src = ../bin/bw-menu;
    phases = [ "installPhase" ];
    dontBuild = true;
    buildInputs = with pkgs; [
      yad
      bitwarden-cli
      ripgrep
      wl-clipboard-rs
      tofi
      libnotify
    ];
    installPhase = ''
      cp -r $src/ $out/
    '';
  };
in
{
  home.packages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli
    bitwarden-nu-menu
  ];
}
