_: {
  programs.git = {
    enable = true;
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
        name = "Elbtalkessel";
        email = "rtfsc@pm.me";
      };

      init = {
        defaultBranch = "master";
      };

      push = {
        autoSetupRemote = true;
      };
    };
  };
}
