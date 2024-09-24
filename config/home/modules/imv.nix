_: {
  programs.imv = {
    enable = true;
    settings = {
      options.supress_default_binds = true;
      binds = {
        q = "quit";
        l = "next";
        h = "prev";
        y = "exec wl-copy $imv_current_file";
      };
    };
  };
}
