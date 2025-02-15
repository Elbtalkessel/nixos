{ pkgs, ... }:
let
  script = pkgs.writeScriptBin "powermenu.nu" ''
    #!/usr/bin/env nu
    let i = {
      " lock": "loginctl lock-session"
      "󰗽 logout": "hyprctl dispatch exit"
      "󰤄 sleep": "systemctl suspend"
      " reboot": "poweroff --reboot"
      " shutdown": "poweroff"
    };
    let key = ($i | columns | str join "\n" | tofi)
    if ($key != "") {
      let cmd = ($i | get $key)
      nu -c $cmd
    }
  '';
in
{
  format = " ";
  on-click = "nu ${script}/bin/powermenu.nu";
}
