_: {
  programs.imv = {
    enable = true;
    settings = {
      # Note: on wayland a command may run infinite times
      # if the imv window unfocuses.
      # https://todo.sr.ht/~exec64/imv/7
      # https://github.com/eXeC64/imv/issues/207#issuecomment-607831458
      # Only workaround is to run it in background &
      binds = {
        y = ''exec wl-copy "$imv_current_file"'';
        u = ''exec setbg "$imv_current_file" &'';
        D = ''exec (rm "$imv_current_file"; imv-msg $imv_pid next) &'';
      };
    };
  };
}
