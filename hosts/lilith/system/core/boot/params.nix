{ lib, ... }: {
  boot = {
    kernelParams = lib.mkDefault [
      "quiet" # reduce kernel log verbosity during boot
      "splash" # enable graphical boot splash Plymouth
      "udev.log_priority=3" # only show udev errors (hide info/debug spam)
      "rd.systemd.show_status=auto" # systemd boot status only when needed (not verbose)
      "boot.shell_on_fail" # drop to shell if boot fails (debug safety net)
      "i8042.nopnp" # disable PS/2 PNP probing (removes i8042 AUX spam)
      "ima=off" # disable IMA subsystem (removes integrity measurement logs)
    ];
    plymouth.enable = true;
  };
}
