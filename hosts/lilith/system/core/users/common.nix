{ config, lib, ... }: {
  users = {
    defaultUserShell = config.my.core.shell.package;
    mutableUsers = false;
  };

  programs.zsh.enable = lib.mkIf (config.my.core.shell.name == "zsh") true;
}
