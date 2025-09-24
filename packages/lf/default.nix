{ pkgs, ... }:
{
  preview = pkgs.nuenv.writeShellApplication {
    name = "preview";
    runtimeInputs = with pkgs; [
      nushell
      # text files
      bat
      # mp3
      id3v2
      # flac
      flac
      # any supported video files
      ffmpeg
      # getting a file mime
      file
      # listing an archive
      ouch
      # image metadata
      exiftool
    ];
    text = builtins.readFile ./preview.nu;
    meta = {
      mainProgram = "preview";
      description = "File previewer for lf";
    };
  };
}
