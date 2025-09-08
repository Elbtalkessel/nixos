{ pkgs, ... }:
{
  preview = pkgs.nuenv.writeShellApplication {
    name = "preview";
    runtimeInputs = with pkgs; [
      nushell
      bat
      id3v2
      flac
      ffmpeg
      file
      ouch
    ];
    text = builtins.readFile ./preview.nu;
    meta = {
      mainProgram = "preview";
      description = "File previewer for lf";
    };
  };
}
