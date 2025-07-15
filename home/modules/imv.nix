_: {
  programs.imv = {
    enable = true;
    settings = {
      binds = {
        q = "quit";
        l = "next";
        h = "prev";
        y = "exec wl-copy \"$imv_current_file\"";
        u = "exec setbg \"$imv_current_file\"";
        d = "exec rm \"$imv_current_file\"";
      };
    };
  };
}
