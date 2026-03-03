{ lib, pkgs, ... }:
let
  # Creates a list of icons, example:
  # [
  #   " ··········"
  #   " •·········"
  #   " ••········"
  #   ...
  # ]
  iconSet =
    pfx:
    (lib.imap0 (
      i: _:
      lib.concatStrings [
        "${pfx} "
        (lib.concatStrings (lib.replicate i "•"))
        (lib.concatStrings (lib.replicate (10 - i) "·"))
      ]
    ) (lib.lists.range 0 10));
in
{
  "format" = "{icon}";
  "tooltip-format" = "{desc} @ {volume}%";
  "format-muted" = "󰝟";
  "format-icons" = {
    # Depends on pulseaudio, if it can recognize type
    # of the device plugged-in. For me, everything is a speaker,
    # so it defaults to "default".
    "default" = (iconSet "");
    "headphone" = (iconSet "󰋋");
    "headset" = (iconSet "󰥰");
  };
  "scroll-step" = 5;
  "on-click" = "${lib.getExe pkgs.pavucontrol}";
}
