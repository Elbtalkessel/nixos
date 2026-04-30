{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.activation = {
    # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
    regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      tofi_cache=${config.xdg.cacheHome}/tofi-drun
      [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
    '';
  };
  xdg.configFile = {
    # Tofi laucher theme
    "tofi/config".source = ../config/tofi/fullscreen;
  };
  home.packages = [
    pkgs.tofi
    # I'd like to call it from the waybar and using shortcut,
    # ideally in the waybar (and hyprland) config it should look like this:
    # "on-click = "nu {how-can-i-reference-this-path-outside-the-module}.nix";
    (pkgs.writeScriptBin "powermenu.nu" ''
      #!/usr/bin/env nu
      let i = {
        " lock": "loginctl lock-session"
        "󰗽 logout": "loginctl terminate-user (whoami)"
        "󰤄 sleep": "systemctl suspend"
        " reboot": "poweroff --reboot"
        " shutdown": "poweroff"
      };
      let key = ($i | columns | str join "\n" | tofi)
      if ($key != "") {
        let cmd = ($i | get $key)
        nu -c $cmd
      }
    '')
  ];
}
