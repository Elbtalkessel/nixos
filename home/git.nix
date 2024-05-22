{ lib, ... }: {
    programs.git = {
      enable = true;
      userName = "Elbtalkessel";
      userEmail = "rtfsc@pm.me";
      aliases = {
        m = "merge --no-ff";
        pp = "push";
        p = "pull";
        c = "commit";
        s = "status";
        a = "add";
        r = "reset --soft HEAD~1";
        cdate = "!git add -A && git commit -m \"$(date)\"";
      };
    };
}
