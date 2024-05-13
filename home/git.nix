{ lib, ... }: {
    programs.git = {
      enable = true;
      userName = "Elbtalkessel";
      userEmail = "rtfsc@pm.me";
      aliases = {
        m = "merge --no-ff";
        p = "push";
        s = "status";
        cdate = "!git add -A && git commit -m \"$(date)\"";
      };
    };
}
