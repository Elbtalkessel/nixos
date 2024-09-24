_: {
  programs.imv = {
    enable = true;
    settings = {
      binds = {
        q = "quit";
        l = "next";
        h = "prev";
        y = "exec wl-copy $imv_current_file";
        # requires wallpaper.sh, see home.nix - programs.
        u = "exec wallpaper $imv_current_file";
      };
    };
  };
}
