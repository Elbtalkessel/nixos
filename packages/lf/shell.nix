let
  pkgs = import <nixpkgs> { };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    nushell
    bat
    id3v2
    flac
    ffmpeg
  ];
}
