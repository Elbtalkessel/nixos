{ pkgs, lib, ... }:
{
  home.packages = [
    # Simple reusable wrapper controlling main output volume level,
    # pass 5%+ or 5%- to increase or decrease volume.
    (pkgs.writeShellApplication {
      name = "set-volume";
      text = # bash
        ''
          ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ "$1"
        '';
    })
    (pkgs.writeShellApplication {
      name = "genplaylists";
      text = builtins.readFile ./genplaylists.sh;
      runtimeInputs = [ pkgs.coreutils ];
    })
  ];
}
