{ lib }:
{
  "format" = "{icon} ";
  "tooltip-format" = "{volume}%";
  "format-muted" = "󰝟";
  "format-icons" = lib.imap0 (
    i: _:
    lib.concatStrings [
      " "
      (lib.concatStrings (lib.replicate i "•"))
      (lib.concatStrings (lib.replicate (10 - i) "·"))
    ]
  ) (lib.lists.range 0 10);
  "scroll-step" = 5;
  "on-click" = "pavucontrol";
}
