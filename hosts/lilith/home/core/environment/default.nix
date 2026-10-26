{
  pkgs,
  lib,
  ...
}:
{
  home = {
    sessionPath = [ "$XDG_BIN_HOME" ];
    sessionVariables = {
      # Configuration variables
      EDITOR = "nvim";
      TERMINAL = "foot";
      VAGRANT_DEFAULT_PROVIDER = "libvirt";
      VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
      # Colored man pages
      MANPAGER = "sh -c 'col -bx | ${lib.getExe pkgs.bat} -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
