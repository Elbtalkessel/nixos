{ config, ... }: {
  users = {
    defaultUserShell = config.my.core.shell.package;
    mutableUsers = false;
  };
}
