{ config, lib, ... }: {
  users = {
    defaultUserShell = config.my.shell.package;
    mutableUsers = false;
  };

  programs.zsh.enable = lib.mkIf (config.my.shell.name == "zsh") true;
}
