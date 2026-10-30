{ config, lib, ... }: {
  programs.git = {
    enable = true;
    signing = lib.mkIf (config.my.apps.git.signingKey != null) {
      format = "openpgp";
      key = config.my.apps.git.signingKey;
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
