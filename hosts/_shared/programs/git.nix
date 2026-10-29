{ config, ... }: {
  programs.git = {
    enable = true;
    signing = {
      format = "openpgp";
      key = "A2CE863D73FCDD65";
      signByDefault = true;
    };
    settings = {
      alias = {
        m = "merge --no-ff";
        p = "pull";
        f = "fetch";
        c = "checkout";
        s = "status";
        a = "add .";
        undo = "reset --soft HEAD~1";
        ccdate = "!git add -A && git commit -m \"$(date)\"";
        graph = "log --decorate --graph --parents";
      };
      user = {
        name = config.my.core.identity.username;
        email = config.my.core.identity.email;
      };
      push.autoSetupRemote = true;
    };
  };
}
