_: {
  home.shellAliases = {
    cat = "bat";
    cp = "cp -iv";
    dc = "docker compose";
    ln = "ln -v";
    mv = "mv -iv";
    n = "$EDITOR";
    rm = "rm -v";
    S = "sudo systemctl";
    s = "sudo";
    Ss = "sudo systemctl status";
    Su = "systemctl --user";
    Sr = "sudo systemctl restart";
    gg = "lazygit";
    g = "git";
    d = "lazydocker";
    mo = "udisksctl mount -b";
    um = "udisksctl unmount -b";
    en = "sudo cryptsetup open";
    de = "sudo cryptsetup close";
    # For monitoring cached data to permanent storage syncronization progress.
    # Example:
    #   cp a_large_file /run/media/risus/pendrive/
    #   sync
    #   watch dirty
    dirty = "grep -e Dirty: -e Writeback: /proc/meminfo";
    lfcd = "cd $(command lf -print-last-dir $argv)";
  };
}
