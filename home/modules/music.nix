{ pkgs, lib, ... }:
let
  MUSIC = /mnt/share/Music;
  enable = false;
in
{
  home.packages = lib.mkIf enable [
    pkgs.mpc-cli
    (pkgs.writeShellScriptBin "genplaylists" (builtins.readFile ../bin/genplaylists.sh))
  ];

  services.mpd = {
    inherit enable;
    musicDirectory = MUSIC;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "Pipewire Audio Output"
      }
    '';
  };

  programs.ncmpcpp = {
    inherit enable;
    mpdMusicDir = MUSIC;
    bindings = [
      {
        key = "+";
        command = "show_clock";
      }
      {
        key = "=";
        command = "volume_up";
      }
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "u";
        command = "page_up";
      }
      {
        key = "d";
        command = "page_down";
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = ".";
        command = "show_lyrics";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }
    ];
  };
}
