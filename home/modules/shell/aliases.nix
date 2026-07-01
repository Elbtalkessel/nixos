{ lib, pkgs, ... }:
{
  home.shellAliases =
    let
      Su = "systemctl --user";
      S = "systemctl";
    in
    {
      inherit Su;
      usta = "${Su} start";
      usto = "${Su} stop";
      ures = "${Su} restart";
      ustat = "${Su} status";
      urel = "${Su} daemon-reload";
      ucat = "${Su} cat";
      utimer = "${Su} list-timers";
      usvc = "${Su} --type=service";

      inherit S;
      ssta = "${S} start";
      ssto = "${S} stop";
      sres = "${S} restart";
      sstat = "${S} status";
      srel = "${S} daemon-reload";
      scat = "${S} cat";
      stimer = "${S} list-timers";
      ssvc = "${S} --type=service";

      cp = "cp -iv";
      ln = "ln -v";
      mv = "mv -iv";
      rm = "rm -v";

      sp = lib.getExe pkgs.nix-search-cli;
      vi = lib.getExe pkgs.neovim;
      n = lib.getExe pkgs.neovim;
      g = lib.getExe pkgs.lazygit;
      d = lib.getExe pkgs.lazydocker;

      poweroff = "${lib.getExe pkgs.hyprshutdown} -t 'Shutting down...' --post-cmd 'poweroff'";
      reboot = "${lib.getExe pkgs.hyprshutdown} -t 'Rebooting...' --post-cmd 'reboot'";
      logout = lib.getExe pkgs.hyprshutdown;
    };
}
