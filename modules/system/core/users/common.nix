{ config, ... }: {
  users = {
    defaultUserShell = config.my.shell.package;
    mutableUsers = false;
  };
}
